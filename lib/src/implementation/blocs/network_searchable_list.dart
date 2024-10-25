import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search functionality with manipulation methods by combining the functionality of [NetworkSearchableBloc] and [NetworkListBloc].Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// typedef MyState = NetworkSearchableListState<Note>;
///
/// class MyNetworkSearchableListBloc
///     extends NetworkSearchableListBloc<Note, MyState> {
///   MyNetworkSearchableListBloc()
///       : super(
///         const MyState(
///           data: [],
///           visibleData: [],
///         ),
///       );
///
///  // MUST be overridden when extending [NetworkListBloc].
///   @override
///   Future<List<Note>> onLoadAsync() async {
///     // ...
///   }
///
///  // Needs to be overridden when extending [NetworkSearchableListBloc] in order to `search` method to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///   // ...
/// }
/// // MUST be overridden when extending [NetworkSearchableListBloc] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///    // ..
///   }
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
