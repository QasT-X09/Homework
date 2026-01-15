import '../models/todo.dart';

class SampleData {
  static List<Todo> todos = [
    Todo(
      id: '1',
      title: 'Купить продукты',
      description: 'Молоко, хлеб, яйца, фрукты',
    ),
    Todo(
      id: '2',
      title: 'Позвонить Ивану',
      description: 'Обсудить детали проекта',
    ),
    Todo(
      id: '3',
      title: 'Прочитать книгу',
      description: 'Глава 4–6',
    ),
  ];
}
