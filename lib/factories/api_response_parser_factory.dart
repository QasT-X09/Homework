import 'package:day37/models/api_response_models.dart';

abstract interface class ApiResponseParser {
  ParsedApiResponse parse(Map<String, dynamic> json);
}

class ApiResponseParserFactory {
  const ApiResponseParserFactory();

  ApiResponseParser create(ApiResponseType type) {
    return switch (type) {
      ApiResponseType.user => const UserResponseParser(),
      ApiResponseType.stats => const StatsResponseParser(),
      ApiResponseType.alert => const AlertResponseParser(),
    };
  }
}

class UserResponseParser implements ApiResponseParser {
  const UserResponseParser();

  @override
  ParsedApiResponse parse(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

class StatsResponseParser implements ApiResponseParser {
  const StatsResponseParser();

  @override
  ParsedApiResponse parse(Map<String, dynamic> json) {
    return StatsResponse(
      visits: json['visits'] as int,
      conversion: (json['conversion'] as num).toDouble(),
      revenue: json['revenue'] as int,
    );
  }
}

class AlertResponseParser implements ApiResponseParser {
  const AlertResponseParser();

  @override
  ParsedApiResponse parse(Map<String, dynamic> json) {
    return AlertResponse(
      title: json['title'] as String,
      severity: json['severity'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}
