import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for search and update operations. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// // The state contains the `data` of any type in this case `List<String>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` will be used to display the data in the UI based on the user's search input, and `query` is used to store the user's search input.
/// typedef MyData = List<String>;
/// typedef MyState = NetworkSearchableState<MyData>;
///
/// class MyNetworkSearchableBloc extends NetworkSearchableBloc<MyData, MyState> {
///   MyNetworkSearchableBloc()
///       : super(
///           const MyState(
///             data: [],
///             // visibleData will be used to display the data in the UI based on the user's search input.
///             visibleData: [],
///           ),
///         );
///
///   // MUST be overridden when extending [NetworkSearchableBloc].
///   @override
///   Future<MyData> onLoadAsync() async {
///     return Future.value(List.generate(1000, (index) => 'Item ${index + 1}'));
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableBloc] to perform search asynchronously.
///   @override
///   Future<MyData> onSearchAsync(String query) async {
///     return Future.value(
///         state.data.where((element) => element.contains(query)).toList());
///   }
///
///   // Needs to be overridden when extending [NetworkSearchableBloc] in order to `search` method to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     final query = state.query;
///     var visibleData = state.data;
///
///     if (query != null && query.isNotEmpty) {
///       visibleData = visibleData
///           .where(
///             (item) => item.contains(query),
///           )
///           .toList();
///     }
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
/// The [onSearchAsync] is invoked when [searchAsync] method is called from the UI.
/// ```dart
/// TextField(
///  onChanged: context.read<MySearchableBloc>().searchAsync,
/// ),
/// ```
///
/// The [search] method is used to search the data with the provided query.
/// ```dart
/// TextField(
///  onChanged: context.read<MySearchableBloc>().search,
/// ),
/// ```
///
/// _Note:_ When working with `BlocBuilder`, the`state.visibleData` should be used.
///
///  Example usage:
///```dart
/// BlocBuilder<MyNetworkSearchableBloc, MyState>(
///   builder: (context, state) {
///     return ListView.builder(
///       itemCount: state.visibleData.length,
///       itemBuilder: (context, index) {
///         final item = state.visibleData[index];
///         return Text(item);
///       },
///     );
///   },
/// );
///```
///
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// // This will update the state with the new data.
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkSearchableBloc>().updateAsync(['New item']);
///   },
///   child: Text('Update Item'),
/// )
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// // This will replace the data with the new value.
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkSearchableBloc>().update(['New item']);
///   },
///   child: Text('Update Item'),
/// )
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// BlocProvider(
///   create: (context) => MyNetworkSearchableBloc()..load(),
///   child: {
///     // Your widget here
///   },
/// )
/// ```
///
abstract class NetworkSearchableBloc<T, S extends NetworkSearchableState<T>>
    extends NetworkBloc<T, S>
    with NetworkSearchableBaseMixin<T, S>, NetworkSearchableBlocMixin<T, S> {
  NetworkSearchableBloc(super.initialState) {
    super.network();
  }
}
