import 'package:day38/data/adapters/note_adapter.dart';
import 'package:day38/data/datasources/local/notes_local_data_source.dart';
import 'package:day38/data/datasources/remote/notes_remote_data_source.dart';
import 'package:day38/domain/entities/note.dart';
import 'package:day38/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({
    required NotesRemoteDataSource remoteDataSource,
    required NotesLocalDataSource localDataSource,
    required NoteAdapter adapter,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _adapter = adapter;

  final NotesRemoteDataSource _remoteDataSource;
  final NotesLocalDataSource _localDataSource;
  final NoteAdapter _adapter;

  @override
  Stream<List<Note>> observeNotes({
    FetchStrategy strategy = FetchStrategy.cacheFirst,
  }) async* {
    switch (strategy) {
      case FetchStrategy.localOnly:
        yield await _localDataSource.readNotes();
      case FetchStrategy.remoteOnly:
        final remoteNotes = await _loadRemoteNotes();
        yield remoteNotes;
      case FetchStrategy.cacheFirst:
        final cachedNotes = await _localDataSource.readNotes();
        yield cachedNotes;

        final remoteNotes = await _loadRemoteNotes();
        yield remoteNotes;
    }
  }

  Future<List<Note>> _loadRemoteNotes() async {
    final rawItems = await _remoteDataSource.fetchNotes();
    final notes = _adapter.fromApiList(rawItems);
    await _localDataSource.saveNotes(notes);
    return notes;
  }
}
