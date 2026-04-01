class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isPinned,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isPinned;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.isPinned == isPinned;
  }

  @override
  int get hashCode => Object.hash(id, title, content, createdAt, isPinned);
}
