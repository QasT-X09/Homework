import 'package:day38/data/datasources/remote/notes_remote_data_source.dart';

class FakeNotesRemoteDataSource implements NotesRemoteDataSource {
  const FakeNotesRemoteDataSource({required this.response});

  final List<Map<String, Object?>> response;

  @override
  Future<List<Map<String, Object?>>> fetchNotes() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return response;
  }
}
