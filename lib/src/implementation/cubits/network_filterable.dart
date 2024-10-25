import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for filtering.
///
/// Example usage:
///
/// ```dart
/// typedef MyData = List<Note>;
/// // Any type can be used here as a filter, for example, `bool`, `int`, `String`, enum, etc.
/// typedef MyState = NetworkFilterableState<MyData, Filter>;
/// // The state contains the `data` of any type in this case `List<Note>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` will be used to display the data in the UI based on the user's search input,`query` is used to store the user's search input, and `filter` is used to store the user's filter.
///
/// class MyNetworkFilterableCubit
///     extends NetworkFilterableCubit<MyData, Filter, MyState> {
///   MyNetworkFilterableCubit()
///       : super(
///         const MyState(
///           data: [],
///           // visibleData will be used to display the data in the UI based on the user's search input.
///           visibleData: [],
///         ),
///       );
///
///   // MUST be overridden when extending [NetworkFilterableCubit].
///   @override
///   Future<MyData> onLoadAsync() async {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableCubit] to perform filtering asynchronously.
///   @override
///   Future<MyData> onFilterAsync(Filter filter) {
///     // ...
///   }
///
///   // Needs to be overridden when extending [NetworkFilterableCubit] in order to `search` and `filter` methods to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     // ...
///   }
///
/// ```
///
/// The [onFilterAsync] is invoked when [filterAsync] method is called from the UI.
/// ```dart
/// context.read<MyNetworkFilterableCubit>().filterAsync(/* filter */),
/// ),
/// ```
///
/// The [filter] method is used to filter the data with the provided filter.
/// ```dart
/// context.read<MyNetworkFilterableCubit>().filter(/* filter */),
/// ```
///
/// __Note:__ When working with `BlocBuilder`, the`state.visibleData` should be used.
///
abstract class NetworkFilterableCubit<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableCubit<T, S>
    with NetworkFilterableBaseMixin<T, F, S> {
  NetworkFilterableCubit(super.initialState);
}
