import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search functionality with manipulation methods by combining the functionality of [NetworkSearchableBloc] and [NetworkListBloc].Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// typedef MyState = NetworkSearchableListState<Data>;
///
/// class MyNetworkSearchableListBloc
///     extends NetworkSearchableListBloc<Data, MyState> {
///   MyNetworkSearchableListBloc()
///       : super(
///         const MyState(
///           data: [],
///           visibleData: [],
///         ),
///       );
/// }
/// ```
///
abstract class NetworkSearchableListBloc<T,
        S extends NetworkSearchableListState<T>> extends NetworkListBloc<T, S>
    with
        NetworkSearchableBaseMixin<List<T>, S>,
        NetworkSearchableBlocMixin<List<T>, S> {
  NetworkSearchableListBloc(super.initialState) {
    super.network();
  }
}
