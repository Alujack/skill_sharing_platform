// lib/core/api/environment.dart
enum AppEnvironment { dev, staging, production }

class EnvironmentConfig {
  static AppEnvironment environment = AppEnvironment.dev;
  
  static String get baseUrl {
    switch (environment) {
      case AppEnvironment.dev:
        return 'http://localhost:4000/v1';
      case AppEnvironment.staging:
        return 'http://staging-api-url.com/v1';
      case AppEnvironment.production:
        return 'http://production-api-url.com/v1';
    }
  }
  
  static void setEnvironment(AppEnvironment env) {
    environment = env;
  }
}
