import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networklistcubit}
/// A utility class that extends [NetworkCubit] to simplify working with asynchronous `List` data, providing [addItem], [addItemAsync], [editItem], [editItemAsync], [removeItem], and [removeItemAsync], and also inheriting [load], [update], and [updateAsync] from [NetworkCubit].
///
/// The [onLoadAsync] and [equals] MUST be overridden when extending [NetworkListCubit].
///
/// ```dart
/// class Note {
///   const Note(this.id, this.item);

///   final int id;
///   final String item;
/// }
/// /// In the state specify <Note> instead of List<Note>.
/// typedef MyListState = NetworkListState<Note>;

/// class MyListCubit extends NetworkListCubit<Note, MyListState> {
///   MyListCubit() : super(const NetworkListState(data: []));
///
///   @override
///   Future<List<Note>> onLoadAsync() async {
///    return someRepository.fetchData();
///   }
///
///   @override
///   bool equals(Note note1, Note note2) {
///     return note1.id == note2.id;
///   }
/// }
/// ```
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
///
/// ```dart
/// context.read<MyListCubit>().load();
/// ```
///
/// The [NetworkListState] is managed by [NetworkListCubit]. The `<T>` in [NetworkListState] represents the type of data that [NetworkListCubit] holds. Only the data type needs to be specified, not a `List<T>`.
///
/// {@endtemplate}
abstract class NetworkListCubit<T, S extends NetworkListState<T>>
    extends NetworkCubit<List<T>, S> with NetworkListBaseMixin<T, S> {
  /// {@macro networklistcubit}
  NetworkListCubit(super.initialState);
}
