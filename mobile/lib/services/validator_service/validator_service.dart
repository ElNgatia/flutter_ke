abstract class ValidatorService {
  static String? emailFormatValidator(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }

    // Regular expression for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null; // null means validation passed
  }

  static bool containsLink(String text) {
    final urlRegex = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(text);
  }

  static String? extractUrl(String text) {
    final match = RegExp(r'(https?:\/\/[^\s]+)').firstMatch(text);
    return match?.group(0);
  }
}
