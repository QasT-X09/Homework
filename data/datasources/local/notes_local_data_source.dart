import 'package:day38/domain/entities/note.dart';

abstract interface class NotesLocalDataSource {
  Future<List<Note>> readNotes();
  Future<void> saveNotes(List<Note> notes);
}
