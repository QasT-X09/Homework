import 'package:day39/features/notes/domain/entities/note.dart';
import 'package:day39/features/notes/domain/repositories/note_repository.dart';
import 'package:day39/features/notes/domain/result/result.dart';

class AddNoteUseCase {
  AddNoteUseCase(this._repository);

  final NoteRepository _repository;

  Future<Result<Note>> call(Note note) async {
    if (note.title.trim().isEmpty) {
      return const Failure<Note>('Title cannot be empty');
    }

    if (note.content.trim().isEmpty) {
      return const Failure<Note>('Content cannot be empty');
    }

    return _repository.addNote(note);
  }
}
