import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for search and update operations.
///
/// Example usage:
///
/// ```dart
/// //  The state contains the `data` of any type in this case `List<String>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` will be used to display the data in the UI based on the user's search input, and `query` is used to store the user's search input.
/// typedef MyData = List<String>;
/// typedef MyState = NetworkSearchableState<MyData>;
///
/// class MyNetworkSearchableCubit extends NetworkSearchableCubit<MyData, MyState> {
///   MyNetworkSearchableCubit()
///       : super(
///           const MyState(
///             data: [],
///             // visibleData will be used to display the data in the UI based on the user's search input.
///             visibleData: [],
///           ),
///         );
///
///   // MUST be overridden when extending [NetworkSearchableCubit].
///   @override
///   Future<MyData> onLoadAsync() async {
///     return Future.value(List.generate(1000, (index) => 'Item ${index + 1}'));
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableCubit] to perform search asynchronously.
///   @override
///   Future<MyData> onSearchAsync(String query) async {
///     return Future.value(
///         state.data.where((element) => element.contains(query)).toList());
///   }
///
///   // Needs to be overridden when extending [NetworkSearchableCubit] in order to `search` method to work.
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
///   // Can optionally be overridden when extending [NetworkSearchableCubit].
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
///  onChanged: context.read<MySearchableCubit>().searchAsync,
/// ),
/// ```
///
/// The [search] method is used to search the data with the provided query.
/// ```dart
/// TextField(
///  onChanged: context.read<MySearchableCubit>().search,
/// ),
/// ```
///
/// _Note:_ When working with `BlocBuilder`, the`state.visibleData` should be used.
///
///  Example usage:
///```dart
/// BlocBuilder<MyNetworkSearchableCubit, MyState>(
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
/// /// // This will update the state with the new data.
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkSearchableCubit>().updateAsync(['New item']);
///   },
///   child: Text('Update Data Async'),
/// )
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// // This will replace the data with the new value.
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkSearchableCubit>().update(['New item']);
///   },
///   child: Text('Update Data'),
/// )
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// BlocProvider(
///   create: (context) => MyNetworkSearchableCubit()..load(),
///   child: {
///     // Your widget here
///   },
/// )
/// ```
///
abstract class NetworkSearchableCubit<T, S extends NetworkSearchableState<T>>
    extends NetworkCubit<T, S> with NetworkSearchableBaseMixin<T, S> {
  NetworkSearchableCubit(super.initialState);
}
