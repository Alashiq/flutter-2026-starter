import 'package:get_storage/get_storage.dart';

class OnboardingStorage {
  static const String _onboardingSeenKey = 'onboarding_seen';

  final GetStorage _storage = GetStorage();

  /// Save that onboarding has been seen
  Future<void> saveOnboardingSeen() async {
    await _storage.write(_onboardingSeenKey, true);
  }

  /// Check if onboarding has been seen
  bool isOnboardingSeen() {
    return _storage.read<bool>(_onboardingSeenKey) ?? false;
  }

  /// Clear onboarding status (for testing/debugging)
  Future<void> clearOnboarding() async {
    await _storage.remove(_onboardingSeenKey);
  }
}
