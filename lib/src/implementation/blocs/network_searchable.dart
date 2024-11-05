import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for search and update operations. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// // The state contains the `data` of any type in this case `List<String>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial],
/// // `visibleData` can be used to display the data in the UI based on the user's search input,
/// // and `query` is used to store the user's search input.
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
///   // Can optionally be overridden when extending [NetworkSearchableBloc] to perform search asynchronously.
///   @override
///   Future<MyData> onSearchAsync(String query) async {
///    // ...
///   }
///
/// // Override this method when extending [NetworkSearchableBloc] to perform a search based on the query passed from the `search` method.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     // ...
///   }
/// }
///```
///
/// The [onSearchAsync] is invoked when [searchAsync] method is called from the UI.
/// ```dart
/// context.read<MySearchableBloc>().searchAsync(/* query */),
/// ```
///
/// The [search] method is used to search the data with the provided query.
/// ```dart
/// context.read<MySearchableBloc>().search(/* query */),
/// ```
///
abstract class NetworkSearchableBloc<T, S extends NetworkSearchableState<T>>
    extends NetworkBloc<T, S>
    with NetworkSearchableBaseMixin<T, S>, NetworkSearchableBlocMixin<T, S> {
  NetworkSearchableBloc(super.initialState) {
    super.network();
  }
}
