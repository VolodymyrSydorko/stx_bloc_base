import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search and filtering functionality with list manipulation methods by combining the functionality of [NetworkFilterableBloc] and [NetworkListBloc]. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// class MyNetworkFilterableListBloc
///     extends NetworkFilterableListBloc<Data, Filter, MyState> {
///   MyNetworkFilterableListBloc()
///       : super(
///           const MyState(
///             data: [],
///             visibleData: [],
///           ),
///         );
/// }
/// ```
abstract class NetworkFilterableListBloc<T, F,
        S extends NetworkFilterableListState<T, F>>
    extends NetworkSearchableListBloc<T, S>
    with
        NetworkFilterableBaseMixin<List<T>, F, S>,
        NetworkFilterableBlocMixin<List<T>, F, S> {
  NetworkFilterableListBloc(super.initialState) {
    super.network();
  }
}
