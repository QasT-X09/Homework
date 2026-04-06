import 'package:flutter_test/flutter_test.dart';
import 'package:lukuka26/patterns/common/task_service.dart';

void main() {
  group('TaskService', () {
    test('load returns empty list by default', () async {
      final service = TaskService();

      final tasks = await service.load();

      expect(tasks, isEmpty);
    });

    test('add inserts task and load returns it', () async {
      final service = TaskService();

      final afterAdd = await service.add('Сделать ДЗ');
      final loaded = await service.load();

      expect(afterAdd, hasLength(1));
      expect(loaded.first.title, 'Сделать ДЗ');
    });

    test('add throws on empty title', () async {
      final service = TaskService();

      expect(() => service.add('   '), throwsA(isA<ArgumentError>()));
    });
  });
}
