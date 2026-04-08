/// lib/core/utils/validators.dart

class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    final emailRegex = RegExp(r'[a-zA-Z0-9@._-+]');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${fieldName ?? 'this field'}';
    }
    return null;
  }

  // Phone number
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    final phoneRegex = RegExp(r'^+?[ds-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter pin';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value!.isEmpty) {
      return "Please enter OTP";
    }
    if (value.length < 6) {
      return "OTP must be at least 6 characters long";
    }
    return null;
  }

  // Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  static String? dropdown(dynamic value) {
    if (value == null) {
      return 'Please select a value';
    }
    // If value is a String, check if it's empty
    if (value is String && value.isEmpty) {
      return 'Please select a value';
    }
    return null;
  }
}
