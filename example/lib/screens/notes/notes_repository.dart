import 'dart:async';

import 'package:example/helpers/list_extentions.dart';
import 'package:example/screens/notes/models/models.dart';

class NotesRepository {
  static List<Note> initalNotes = [
    const Note(noteId: 1, message: 'Note1'),
    const Note(noteId: 2, message: 'Note2'),
    const Note(noteId: 3, message: 'Note3'),
    const Note(noteId: 4, message: 'Note4'),
    const Note(noteId: 5, message: 'Note5'),
  ];

  Future<List<Note>> getNotes() {
    return Future.value([...initalNotes]);
  }

  Future<Note> addNote(Note note) {
    initalNotes.add(note);
    return Future.value(note);
  }

  Future<Note> updateNote(Note note) {
    initalNotes.replaceWhere(
        (item) => item.noteId == note.noteId, (_) => note, false);

    return Future.value(note);
  }

  Future<bool> deleteNote(int id) async {
    final noteToDelete = initalNotes.firstWhere((note) => note.noteId == id);
    initalNotes.remove(noteToDelete);

    return true;
  }
}
