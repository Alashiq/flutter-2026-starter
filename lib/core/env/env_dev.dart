import 'env.dart';

class EnvDev implements Env {
  const EnvDev();

  @override
  String get appName => 'Starter (Dev)';

  @override
  String get baseUrl => 'http://192.168.88.164:8000/api/v1/app/';

  @override
  Flavor get flavor => Flavor.dev;
}
