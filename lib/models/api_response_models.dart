enum ApiResponseType { user, stats, alert }

sealed class ParsedApiResponse {
  const ParsedApiResponse();

  String get summary;
}

class UserResponse extends ParsedApiResponse {
  const UserResponse({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  @override
  String get summary => 'User #$id: $name <$email>';
}

class StatsResponse extends ParsedApiResponse {
  const StatsResponse({
    required this.visits,
    required this.conversion,
    required this.revenue,
  });

  final int visits;
  final double conversion;
  final int revenue;

  @override
  String get summary =>
      'Stats: $visits visits, $conversion% conversion, \$$revenue revenue';
}

class AlertResponse extends ParsedApiResponse {
  const AlertResponse({
    required this.title,
    required this.severity,
    required this.isActive,
  });

  final String title;
  final String severity;
  final bool isActive;

  @override
  String get summary =>
      'Alert: $title, severity $severity, active: ${isActive ? 'yes' : 'no'}';
}
