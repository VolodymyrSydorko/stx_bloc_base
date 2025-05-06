import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search functionality with list manipulation methods by combining the functionality of [NetworkSearchableCubit] and [NetworkListCubit].
///
/// Example usage:
///
/// ```dart
/// typedef MyState = NetworkSearchableListState<Data>;
///
/// class MyNetworkSearchableListCubit
///     extends NetworkSearchableListCubit<Data, MyState> {
///   MyNetworkSearchableListCubit()
///       : super(
///         const MyState(
///           data: [],
///           visibleData: [],
///         ),
///       );
/// }
/// ```
///
abstract class NetworkSearchableListCubit<T,
        S extends NetworkSearchableListState<T>> extends NetworkListCubit<T, S>
    with NetworkSearchableBaseMixin<List<T>, S> {
  NetworkSearchableListCubit(super.initialState);
}
