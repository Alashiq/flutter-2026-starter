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

  // new falidator for libya phone  - 09xxxxxxxx and should be number and required
  static String? libyaPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    if (value.trim().length != 10) {
      return 'رقم الهاتف يجب أن يحتوي على 10 أحرف';
    }
    if (!value.trim().startsWith('09')) {
      return 'رقم الهاتف يجب أن يبدأ ب 09';
    }
    return null;
  }
}
