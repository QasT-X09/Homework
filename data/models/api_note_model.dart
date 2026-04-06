class ApiNoteModel {
  const ApiNoteModel({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;

  static ApiNoteModel? tryParse(Map<String, Object?> json) {
    final id = json['id'];
    final title = json['title'];
    final body = json['body'];

    if (id is! int || title is! String || body is! String) {
      return null;
    }

    if (title.trim().isEmpty || body.trim().isEmpty) {
      return null;
    }

    return ApiNoteModel(id: id, title: title, body: body);
  }
}
