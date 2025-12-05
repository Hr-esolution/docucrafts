class ValidationUtils {
  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    );
    return urlRegex.hasMatch(url);
  }

  /// Validate phone number format (basic validation)
  static bool isValidPhone(String phone) {
    // Remove all non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    // Basic check: length between 7 and 15 digits
    return cleanPhone.length >= 7 && cleanPhone.length <= 15;
  }

  /// Validate if a string is not empty or null
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validate if a number is positive
  static bool isPositiveNumber(double? number) {
    return number != null && number > 0;
  }

  /// Validate if a number is not negative
  static bool isNonNegativeNumber(double? number) {
    return number != null && number >= 0;
  }

  /// Validate password strength (basic validation)
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    bool hasDigit = RegExp(r'\d').hasMatch(password);
    bool hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    
    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }
}