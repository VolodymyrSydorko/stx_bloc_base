import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous data, specifically for search and update operations.
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
///   // Can optionally be overridden when extending [NetworkSearchableCubit] to perform search asynchronously.
///   @override
///   Future<MyData> onSearchAsync(String query) async {
///    // ...
///   }
///
/// // Override this method when extending [NetworkSearchableCubit] to perform a search based on the query passed from the `search` method.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     // ...
///   }
/// }
///```
///
/// The [onSearchAsync] is invoked when [searchAsync] method is called from the UI.
/// ```dart
/// context.read<MySearchableCubit>().searchAsync(/* query */),
/// ```
///
/// The [search] method is used to search the data with the provided query.
/// ```dart
/// context.read<MySearchableCubit>().search(/* query */),
/// ```
///
abstract class NetworkSearchableCubit<T, S extends NetworkSearchableState<T>>
    extends NetworkCubit<T, S> with NetworkSearchableBaseMixin<T, S> {
  NetworkSearchableCubit(super.initialState);
}
