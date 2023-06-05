import 'package:app_restart_observer/enum.dart';

class AppRestartData {
  bool isRestarted;
  AppRestartType? appRestartType;

  AppRestartData({required this.isRestarted, this.appRestartType});

  AppRestartData copyWith({
    required bool isRestarted,
    AppRestartType? appRestartType,
  }) =>
      AppRestartData(
        isRestarted: this.isRestarted,
        appRestartType: appRestartType ?? this.appRestartType,
      );

  Map<String, dynamic> toJson() => {
        'isRestarted': isRestarted,
        'appRestartType': appRestartType.toString(),
      };
}
