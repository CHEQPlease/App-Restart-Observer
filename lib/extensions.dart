import 'package:app_restart_observer/enum.dart';

extension AppRestartTypeExtension on AppRestartType {
  String get label {
    switch (this) {
      case AppRestartType.userIntended:
        return 'User Intended';
      case AppRestartType.systemCrash:
        return 'System Crash';
      default:
        return '';
    }
  }
}