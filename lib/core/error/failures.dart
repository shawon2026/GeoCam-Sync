import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server failures for API errors
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Validation failures for input validation errors
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    required super.message,
    super.statusCode,
    this.errors,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];

  /// Get all error messages as a flat list
  List<String> get errorMessages {
    if (errors == null || errors!.isEmpty) return [message];

    final List<String> messages = [];
    errors!.forEach((key, value) {
      if (value is List) {
        messages.addAll(value.map((e) => e.toString()));
      } else {
        messages.add(value.toString());
      }
    });
    return messages;
  }

  /// Get first error message
  String get firstError {
    if (errors == null || errors!.isEmpty) return message;

    final firstKey = errors!.keys.first;
    final firstValue = errors![firstKey];

    if (firstValue is List && firstValue.isNotEmpty) {
      return firstValue.first.toString();
    }
    return firstValue.toString();
  }
}
