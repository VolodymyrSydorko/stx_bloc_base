import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for filtering. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// typedef MyData = List<Data>;
/// // Any type can be used here as a filter, for example, `bool`, `int`, `String`, enum, etc.
/// typedef MyState = NetworkFilterableState<MyData, Filter>;
/// // The state contains the `data` of any type in this case `List<Data>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` can be used to display the data in the UI based on the user's search input,`query` is used to store the user's search input, and `filter` is used to store the user's filter.
///
/// class MyNetworkFilterableBloc
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
///   // Can optionally be overridden when extending [NetworkFilterableBloc] to perform filtering asynchronously.
///   @override
///   Future<MyData> onFilterAsync(Filter filter) {
///     // ...
///   }
///
/// // Override this method when extending [NetworkFilterableBloc] to perform a search based on the query passed from the `search` method or to filter the data based on the filter passed from the `filter` method.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     // ...
///   }
/// }
/// ```
///
/// The [onFilterAsync] is invoked when [filterAsync] method is called from the UI.
/// ```dart
/// context.read<MyNetworkFilterableBloc>().filterAsync(/* filter */),
/// ),
/// ```
///
/// The [filter] method is used to filter the data with the provided filter.
/// ```dart
/// context.read<MyNetworkFilterableBloc>().filter(/* filter */),
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
