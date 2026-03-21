import 'package:day38/data/datasources/local/notes_local_data_source.dart';
import 'package:day38/data/models/local_note_cache_model.dart';
import 'package:day38/domain/entities/note.dart';

class InMemoryNotesLocalDataSource implements NotesLocalDataSource {
  InMemoryNotesLocalDataSource({List<Note> seed = const []})
    : _cache = seed.map(LocalNoteCacheModel.fromDomain).toList();

  List<LocalNoteCacheModel> _cache;

  @override
  Future<List<Note>> readNotes() async {
    return _cache.map((note) => note.toDomain()).toList(growable: false);
  }

  @override
  Future<void> saveNotes(List<Note> notes) async {
    _cache = notes.map(LocalNoteCacheModel.fromDomain).toList(growable: false);
  }
}
