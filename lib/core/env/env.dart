enum Flavor { dev, prod }

abstract class Env {
  String get baseUrl;
  String get appName;
  Flavor get flavor;
}
