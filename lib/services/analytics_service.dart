class AnalyticsService {
  AnalyticsService._internal() : instanceId = identityHashCode(Object()) {
    _creationCount++;
  }

  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  static AnalyticsService get instance => _instance;

  static int _creationCount = 0;

  static int get creationCount => _creationCount;

  final int instanceId;
  final List<String> _logs = [];

  List<String> get logs => List.unmodifiable(_logs);

  void log(String event) {
    _logs.add(event);
  }
}
