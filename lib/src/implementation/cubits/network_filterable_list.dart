import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search and filtering functionality with list manipulation methods by combining the functionality of [NetworkFilterableCubit] and [NetworkListCubit].
///
///Example usage:
///
///```dart
/// class MyNetworkFilterableListCubit
///     extends NetworkFilterableListCubit<Note, Filter, MyState> {
///   MyNetworkFilterableListCubit()
///       : super(
///           const MyState(
///             data: [],
///             visibleData: [],
///           ),
///         );
///
///   // MUST be overridden when extending [NetworkListCubit].
///   @override
///   Future<List<Note>> onLoadAsync() async {
///     // ...
///   }
///
///   // Needs to be overridden when extending [NetworkFilterableListCubit] in order to `search` and `filter` methods to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     /// ..
///   }
///
///   // MUST be overridden when extending [NetworkFilterableListCubit] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     // ...
///   }
///
///```
///
abstract class NetworkFilterableListCubit<T, F,
        S extends NetworkFilterableListState<T, F>>
    extends NetworkSearchableListCubit<T, S>
    with NetworkFilterableBaseMixin<List<T>, F, S> {
  NetworkFilterableListCubit(super.initialState);
}
