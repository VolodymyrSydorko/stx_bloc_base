import 'package:example/screens/notes/models/models.dart';
import 'package:example/screens/notes/notes_repository.dart';
import 'package:stx_bloc_base/stx_bloc_base.dart';

/// bloc.state.filter [bool] means if note id is odd number
class NotesBloc extends NetworkFilterableListBloc<Note, bool,
    NetworkFilterableListState<Note, bool>> {
  NotesBloc({
    required this.repository,
  }) : super(
          const NetworkFilterableListState(data: [], visibleData: []),
        );

  final NotesRepository repository;

  @override
  Future<List<Note>> onLoadAsync() {
    return repository.getNotes();
  }

  @override
  Future<Note> onAddItemAsync(Note newItem) {
    return repository.addNote(newItem);
  }

  @override
  Future<Note> onEditItemAsync(Note updatedItem) {
    return repository.updateNote(updatedItem);
  }

  @override
  Future<bool> onRemoveItemAsync(Note removedItem) {
    return repository.deleteNote(removedItem.noteId);
  }

  @override
  bool equals(Note item1, Note item2) {
    return item1.noteId == item2.noteId;
  }

  @override
  NetworkFilterableListState<Note, bool> onStateChanged(state) {
    final query = state.query;
    final filter = state.filter;

    var visibleData = state.data;

    if (query != null && query.isNotEmpty) {
      visibleData = visibleData
          .where(
            (note) => note.message.contains(query),
          )
          .toList();
    }

    if (filter != null) {
      visibleData = visibleData
          .where(
            (note) => note.noteId % 2 == 1 ? filter : !filter,
          )
          .toList();
    }

    return state.copyWith(visibleData: visibleData);
  }
}
