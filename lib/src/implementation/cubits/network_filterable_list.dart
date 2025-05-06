import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search and filtering functionality with list manipulation methods by combining the functionality of [NetworkFilterableCubit] and [NetworkListCubit].
///
/// Example usage:
///
/// ```dart
/// class MyNetworkFilterableListCubit
///     extends NetworkFilterableListCubit<Data, Filter, MyState> {
///   MyNetworkFilterableListCubit()
///       : super(
///           const MyState(
///             data: [],
///             visibleData: [],
///           ),
///         );
/// }
/// ```
abstract class NetworkFilterableListCubit<T, F,
        S extends NetworkFilterableListState<T, F>>
    extends NetworkSearchableListCubit<T, S>
    with NetworkFilterableBaseMixin<List<T>, F, S> {
  NetworkFilterableListCubit(super.initialState);
}
