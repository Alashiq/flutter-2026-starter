import 'env.dart';

class EnvProd implements Env {
  const EnvProd();

  @override
  String get appName => 'Starter';

  @override
  String get baseUrl => 'http://192.168.88.164:8000/api/v1/app/';

  @override
  Flavor get flavor => Flavor.prod;
}
