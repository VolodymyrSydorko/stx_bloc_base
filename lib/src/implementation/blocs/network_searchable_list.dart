import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networksearchablelistbloc}
/// A utility class that combines search functionality with list management. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// The [onLoadAsync] and [equals] MUST be overridden when extending [NetworkSearchableListBloc]. Also, to perform [search] or [searchAsync] the [onStateChanged] must also be overridden.
///```dart
/// class Note {
///   const Note(this.id, this.message);
///
///   final int id;
///   final String message;
/// }
/// /// In the state specify <Note> instead of List<Note>.
/// typedef MyListState = NetworkSearchableListState<Note>;
///
/// class MySearchableListBloc extends NetworkSearchableListBloc<Note, MyListState> {
///   MySearchableListCubit()
///      : super(
///           const MyListState(
///             data: [],
///             visibleData: [],
///           ),
///         );
///
///   @override
///   Future<List<Note>> onLoadAsync() async {
///     return someRepository.fetchData();
///   }
///
///   @override
///   MyListState onStateChanged(DataChangeReason reason, MyListState state) {
///     final query = state.query;
///     var visibleData = state.data;
///
///     if (query != null && query.isNotEmpty) {
///       visibleData =
///           visibleData.where((note) => note.message.contains(query)).toList();
///     }
///
///     return state.copyWith(visibleData: visibleData);
///   }
///
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item2.id;
///   }
/// }
///```
/// {@endtemplate}
abstract class NetworkSearchableListBloc<T,
        S extends NetworkSearchableListState<T>> extends NetworkListBloc<T, S>
    with
        NetworkSearchableBaseMixin<List<T>, S>,
        NetworkSearchableBlocMixin<List<T>, S> {
  /// {@macro networksearchablelistbloc}
  NetworkSearchableListBloc(super.initialState) {
    super.network();
  }
}
