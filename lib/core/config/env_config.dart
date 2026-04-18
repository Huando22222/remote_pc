enum Environment { dev, prod }

class EnvConfig {
  static const Environment current = Environment.dev;

  static bool get isDev => current == Environment.dev;
}
