import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for filtering.
///
/// Example usage:
///
/// ```dart
/// typedef MyData = List<Data>;
/// // Any type can be used here as a filter, for example, `bool`, `int`, `String`, enum, etc.
/// typedef MyState = NetworkFilterableState<MyData, Filter>;
/// // The state contains the `data` of any type in this case `List<Data>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` can be used to display the data in the UI based on the user's search input,`query` is used to store the user's search input, and `filter` is used to store the user's filter.
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
///   // Can optionally be overridden when extending [NetworkFilterableCubit] to perform filtering asynchronously.
///   @override
///   Future<MyData> onFilterAsync(Filter filter) {
///     // ...
///   }
///
/// // Override this method when extending [NetworkFilterableCubit] to perform a search based on the query passed from the `search` method or to filter the data based on the filter passed from the `filter` method.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     // ...
///   }
/// }
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
abstract class NetworkFilterableCubit<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableCubit<T, S>
    with NetworkFilterableBaseMixin<T, F, S> {
  NetworkFilterableCubit(super.initialState);
}
