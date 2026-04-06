import 'package:day38/domain/entities/note.dart';

enum FetchStrategy { localOnly, remoteOnly, cacheFirst }

abstract interface class NotesRepository {
  Stream<List<Note>> observeNotes({
    FetchStrategy strategy = FetchStrategy.cacheFirst,
  });
}
