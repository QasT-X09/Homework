abstract interface class NotesRemoteDataSource {
  Future<List<Map<String, Object?>>> fetchNotes();
}
