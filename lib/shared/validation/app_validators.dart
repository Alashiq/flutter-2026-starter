class AppValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.trim().length < min) {
      return 'يجب أن يحتوي النص على $min أحرف على الأقل';
    }
    return null;
  }
}
