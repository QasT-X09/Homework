import 'package:day38/data/adapters/note_adapter.dart';
import 'package:day38/data/datasources/local/in_memory_notes_local_data_source.dart';
import 'package:day38/data/datasources/remote/fake_notes_remote_data_source.dart';
import 'package:day38/data/repositories/notes_repository_impl.dart';
import 'package:day38/domain/entities/note.dart';
import 'package:day38/domain/repositories/notes_repository.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NotesRepository repository = NotesRepositoryImpl(
      remoteDataSource: FakeNotesRemoteDataSource(
        response: const [
          {'id': 1, 'title': 'Server note', 'body': 'Updated from remote API'},
          {'id': 2, 'title': 'Sync status', 'body': 'Cache refreshed'},
        ],
      ),
      localDataSource: InMemoryNotesLocalDataSource(
        seed: const [
          Note(
            id: 'cached-1',
            title: 'Cached note',
            description: 'Loaded from local storage first',
          ),
        ],
      ),
      adapter: const NoteAdapter(),
    );

    return MaterialApp(
      title: 'Notes Repository Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E4F)),
        scaffoldBackgroundColor: const Color(0xFFF6F3EA),
      ),
      home: NotesPage(repository: repository),
    );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key, required this.repository});

  final NotesRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: StreamBuilder<List<Note>>(
        stream: repository.observeNotes(strategy: FetchStrategy.cacheFirst),
        builder: (context, snapshot) {
          final notes = snapshot.data ?? const <Note>[];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Local cache -> remote refresh',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (notes.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No notes available'),
                  ),
                )
              else
                for (final note in notes)
                  Card(
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.description),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
