import 'package:day38/data/models/api_note_model.dart';
import 'package:day38/domain/entities/note.dart';

class NoteAdapter {
  const NoteAdapter();

  List<Note> fromApiList(List<Map<String, Object?>> rawItems) {
    return rawItems
        .map(ApiNoteModel.tryParse)
        .whereType<ApiNoteModel>()
        .map(
          (apiNote) => Note(
            id: apiNote.id.toString(),
            title: apiNote.title,
            description: apiNote.body,
          ),
        )
        .toList(growable: false);
  }
}
