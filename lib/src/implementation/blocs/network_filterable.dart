import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for filtering. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// class Note {
///   Note(this.id, this.message);
///
///   final int id;
///   final String message;
/// }
///
/// enum Filter {
///   even,
///   odd;
///
///   bool get isEven => this == Filter.even;
///   bool get isOdd => this == Filter.odd;
/// }
///
/// typedef MyData = List<Note>;
/// // Here `Filter` is used to filter the data by `id`. Any type can be used here, for example, `bool`, `int`, `String`, enum, etc.
/// typedef MyState = NetworkFilterableState<MyData, Filter>;
///
/// // The state contains the `data` of any type in this case `List<Note>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` will be used to display the data in the UI based on the user's search input, and `query` is used to store the user's search input and `filter` is used to store the user's filter input.
///
/// class MyNetworkFilterableBloc
/// // The `Filter` is used to filter the data by `id`.
///     extends NetworkFilterableBloc<MyData, Filter, MyState> {
///   MyNetworkFilterableBloc()
///       : super(
///         const MyState(
///           data: [],
///           // visibleData will be used to display the data in the UI based on the user's search input.
///           visibleData: [],
///         ),
///       );
///
///   // MUST be overridden when extending [NetworkFilterableBloc].
///   @override
///   Future<MyData> onLoadAsync() async {
///     return Future.value(List.generate(100, (index) {
///       return Note(index + 1, 'Note ${index + 1}');
///     }));
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableBloc] to perform filtering asynchronously.
///   @override
///   Future<MyData> onFilterAsync(Filter filter) {
///     return Future.value(state.data
///         .where(
///           (element) => filter.isEven ? element.id.isEven : element.id.isOdd)
///         .toList());
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterBloc] to perform search asynchronously.
///   @override
///   Future<MyData> onSearchAsync(String query) async {
///     return Future.value(state.data
///         .where((element) => element.message.contains(query))
///         .toList());
///   }
///
///   // Needs to be overridden when extending [NetworkFilterableBloc] in order to `search` and `filter` methods to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     final query = state.query;
///     final filter = state.filter;
///
///     var visibleData = state.data;
///
///     if (query != null && query.isNotEmpty) {
///       visibleData = visibleData
///           .where(
///             (item) => item.message.contains(query),
///           )
///           .toList();
///     }
///
///     if (filter != null) {
///       visibleData = visibleData
///           .where(
///             (item) => filter.isEven ? item.id.isEven : item.id.isOdd,
///           )
///           .toList();
///     }
///
///     return state.copyWith(visibleData: visibleData);
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableBloc].
///   @override
///   Future<MyData> onUpdateAsync(updatedData) async {
///     return Future.value([
///       ...updatedData,
///       ...state.data,
///     ]);
///   }
/// }
/// ```
///
/// The [onFilterAsync] is invoked when [filterAsync] method is called from the UI.
/// ```dart
/// TextButton(
///  onPressed: () => context.read<MyNetworkFilterableBloc>().filterAsync(Filter.even),
/// child: const Text('By even numbers'),
/// )
/// ```
///
/// The [filter] method is used to filter the data with the provided filter.
/// ```dart
/// TextButton(
/// onPressed: () => context.read<MyNetworkFilterableBloc>().filter(Filter.odd),
/// child: const Text('By odd numbers'),
/// )
/// ```
///
/// The [onSearchAsync] is invoked when [searchAsync] method is called from the UI.
/// ```dart
/// TextField(
/// onChanged: context.read<MyNetworkFilterableBloc>().searchAsync,
/// ),
/// ```
///
/// The [search] method is used to search the data with the provided query.
/// ```dart
/// TextField(
/// onChanged: context.read<MyNetworkFilterableBloc>().search,
/// ),
/// ```
///
/// _Note:_ When working with `BlocBuilder`, the`state.visibleData` should be used.
/// Example usage:
///```dart
/// BlocBuilder<MyNetworkFilterableBloc, MyState>(
///   builder: (context, state) {
///     return ListView.builder(
///       itemCount: state.visibleData.length,
///       itemBuilder: (context, index) {
///         final item = state.visibleData[index].message;
///         return Text(item);
///       },
///     );
///   },
/// );
///```
///
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkFilterableBloc>().updateAsync([Note(101, 'New item')]);
///   },
///   child: Text('Update Item'),
/// )
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// TextButton(
///  onPressed: () {
///   context.read<MyNetworkFilterableBloc>().update([Note(101, 'New item')]);
/// },
/// child: Text('Update Item'),
/// )
/// ```
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// BlocProvider(
///  create: (context) => MyNetworkFilterableBloc()..load(),
/// child: {
///  // Your widget here
/// },
/// )
/// ```
///
abstract class NetworkFilterableBloc<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableBloc<T, S>
    with
        NetworkFilterableBaseMixin<T, F, S>,
        NetworkFilterableBlocMixin<T, F, S> {
  NetworkFilterableBloc(super.initialState) {
    super.network();
  }
}
