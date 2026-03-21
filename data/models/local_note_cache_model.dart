import 'package:day38/domain/entities/note.dart';

class LocalNoteCacheModel {
  const LocalNoteCacheModel({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  factory LocalNoteCacheModel.fromDomain(Note note) {
    return LocalNoteCacheModel(
      id: note.id,
      title: note.title,
      description: note.description,
    );
  }

  Note toDomain() {
    return Note(id: id, title: title, description: description);
  }
}
