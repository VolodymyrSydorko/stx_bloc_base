import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search functionality with list manipulation methods by combining the functionality of [NetworkSearchableCubit] and [NetworkListCubit].
///
/// Example usage:
///
/// ```dart
/// typedef MyState = NetworkSearchableListState<Note>;
///
/// class MyNetworkSearchableListCubit
///     extends NetworkSearchableListCubit<Note, MyState> {
///   MyNetworkSearchableListCubit()
///       : super(
///         const MyState(
///           data: [],
///           visibleData: [],
///         ),
///       );
///
///  // MUST be overridden when extending [NetworkListCubit].
///   @override
///   Future<List<Note>> onLoadAsync() async {
///     // ...
///   }
///
///  // Needs to be overridden when extending [NetworkSearchableListCubit] in order to `search` method to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///   // ...
/// }
/// // MUST be overridden when extending [NetworkSearchableListCubit] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///    // ..
///   }
/// ```
///
abstract class NetworkSearchableListCubit<T,
        S extends NetworkSearchableListState<T>> extends NetworkListCubit<T, S>
    with NetworkSearchableBaseMixin<List<T>, S> {
  NetworkSearchableListCubit(super.initialState);
}
