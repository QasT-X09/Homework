import 'package:day39/features/notes/domain/entities/note.dart';
import 'package:day39/features/notes/domain/result/result.dart';

abstract class NoteRepository {
  Future<Result<Note>> addNote(Note note);
}
