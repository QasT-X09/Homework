import 'package:day37/factories/api_response_parser_factory.dart';
import 'package:day37/factories/status_widget_factory.dart';
import 'package:day37/models/api_response_models.dart';
import 'package:day37/services/analytics_service.dart';
import 'package:flutter/material.dart';

void main() {
  AnalyticsService.instance.log('app_started');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patterns Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E7490),
          brightness: Brightness.light,
        ),
      ),
      home: const PatternsDemoPage(),
    );
  }
}

class PatternsDemoPage extends StatefulWidget {
  const PatternsDemoPage({super.key});

  @override
  State<PatternsDemoPage> createState() => _PatternsDemoPageState();
}

class _PatternsDemoPageState extends State<PatternsDemoPage> {
  final AnalyticsService _analytics = AnalyticsService.instance;
  final ApiResponseParserFactory _parserFactory =
      const ApiResponseParserFactory();

  StatusType _status = StatusType.loading;
  ApiResponseType _selectedType = ApiResponseType.user;
  ParsedApiResponse? _parsedResponse;

  final Map<ApiResponseType, Map<String, dynamic>> _mockResponses = {
    ApiResponseType.user: {
      'id': 7,
      'name': 'Aruzhan',
      'email': 'aruzhan@example.com',
    },
    ApiResponseType.stats: {'visits': 1240, 'conversion': 4.8, 'revenue': 9200},
    ApiResponseType.alert: {
      'title': 'API latency',
      'severity': 'high',
      'isActive': true,
    },
  };

  final List<PatternComparisonItem> _comparisonItems = const [
    PatternComparisonItem(
      title: '1. Простота',
      singletonFactory:
          'Легко внедрить без дополнительных пакетов, удобно для небольшого проекта.',
      getIt:
          'Нужно настроить контейнер, но структура зависимостей становится явной.',
    ),
    PatternComparisonItem(
      title: '2. Контроль зависимостей',
      singletonFactory:
          'Зависимости прячутся внутри кода, из-за чего сложнее отследить связи.',
      getIt:
          'Все регистрации собраны в одном месте, проще понимать граф зависимостей.',
    ),
    PatternComparisonItem(
      title: '3. Тестируемость',
      singletonFactory:
          'Тесты проще для старта, но глобальное состояние нужно аккуратно сбрасывать.',
      getIt:
          'Моки и подмены подключаются проще, особенно в большом приложении.',
    ),
    PatternComparisonItem(
      title: '4. Масштабирование',
      singletonFactory:
          'Подходит для локальных сервисов и демо, но начинает мешать при росте модулярности.',
      getIt:
          'Лучше работает в сложной архитектуре с большим числом сервисов и экранов.',
    ),
    PatternComparisonItem(
      title: '5. Явность использования',
      singletonFactory:
          'Вызов короткий: AnalyticsService.instance, но это усиливает глобальную связность.',
      getIt:
          'Получение через контейнер требует дисциплины, зато зависимости проще стандартизировать.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _analytics.log('home_opened');
    _parseSelectedResponse();
  }

  void _parseSelectedResponse() {
    final parser = _parserFactory.create(_selectedType);
    final parsed = parser.parse(_mockResponses[_selectedType]!);

    setState(() {
      _parsedResponse = parsed;
      _status = StatusType.success;
    });

    _analytics.log('response_parsed:${_selectedType.name}');
  }

  void _simulateFailure() {
    setState(() {
      _status = StatusType.error;
    });

    _analytics.log('error_shown');
  }

  @override
  Widget build(BuildContext context) {
    final parsedResponse = _parsedResponse;

    return Scaffold(
      appBar: AppBar(title: const Text('Singleton + Factory')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            'Паттерны в реальной Flutter-задаче',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Singleton хранит аналитику, а Factory создаёт статусные виджеты '
            'и нужный парсер API по типу ответа.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Singleton: AnalyticsService',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID экземпляра: ${_analytics.instanceId}'),
                Text('Созданий сервиса: ${AnalyticsService.creationCount}'),
                const SizedBox(height: 12),
                const Text('Использование в 3 местах приложения:'),
                const SizedBox(height: 8),
                const Text('1. В main() при старте приложения.'),
                const Text('2. В initState() домашнего экрана.'),
                const Text('3. При парсинге и показе ошибок пользователю.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Factory: статусные виджеты',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: StatusType.values.map((status) {
                    return ChoiceChip(
                      label: Text(status.name),
                      selected: _status == status,
                      onSelected: (_) {
                        setState(() {
                          _status = status;
                        });
                        _analytics.log('status_changed:${status.name}');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                StatusWidgetFactory.create(
                  _status,
                  message: switch (_status) {
                    StatusType.loading => 'Загрузка данных с сервера...',
                    StatusType.success => 'Ответ API успешно обработан.',
                    StatusType.error => 'Не удалось получить корректный ответ.',
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Factory: парсинг API по типу',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ApiResponseType.values.map((type) {
                    return ChoiceChip(
                      label: Text(type.name),
                      selected: _selectedType == type,
                      onSelected: (_) {
                        setState(() {
                          _selectedType = type;
                          _status = StatusType.loading;
                        });
                        _analytics.log('response_type_selected:${type.name}');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilledButton(
                      onPressed: _parseSelectedResponse,
                      child: const Text('Parse response'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _simulateFailure,
                      child: const Text('Show error'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Mock payload: ${_mockResponses[_selectedType]}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (parsedResponse != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Результат: ${parsedResponse.summary}',
                    key: const ValueKey('parsed-summary'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Сравнение с get_it',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _comparisonItems
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text('Singleton + Factory: ${item.singletonFactory}'),
                          Text('DI через get_it: ${item.getIt}'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'События аналитики',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _analytics.logs
                  .map((entry) => Text('• $entry'))
                  .toList(),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class PatternComparisonItem {
  const PatternComparisonItem({
    required this.title,
    required this.singletonFactory,
    required this.getIt,
  });

  final String title;
  final String singletonFactory;
  final String getIt;
}
