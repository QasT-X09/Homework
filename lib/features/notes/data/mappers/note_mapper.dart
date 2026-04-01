import 'package:day39/features/notes/data/dto/note_dto.dart';
import 'package:day39/features/notes/domain/entities/note.dart';

class NoteMapper {
  const NoteMapper();

  Note toDomain(NoteDto dto) {
    final parsedDate = DateTime.tryParse(dto.createdAt);
    if (parsedDate == null) {
      throw FormatException('Invalid createdAt value: ${dto.createdAt}');
    }

    return Note(
      id: dto.id.trim(),
      title: dto.title.trim(),
      content: dto.content.trim(),
      createdAt: parsedDate.toUtc(),
      isPinned: dto.isPinned,
    );
  }
}
