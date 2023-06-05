import 'package:hive_flutter/hive_flutter.dart';

class HiveUtils {
  static final HiveUtils _instance = HiveUtils._internal();

  factory HiveUtils() => _instance;

  HiveUtils._internal();

  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<void> setBoolean(String key, bool value) async {
    var restartDataBox = await Hive.openBox(HiveStoreKey.restartDataBox);

    restartDataBox.put(key, value);
  }

  Future<bool?> getBoolean(String key) async {
    var restartDataBox = await Hive.openBox(HiveStoreKey.restartDataBox);

    return restartDataBox.get(key);
  }
}

class HiveStoreKey {
  static const restartDataBox = 'com.cheqplease.appRestartObserver';
  static const isAppLaunchedForTheFirstTime = 'isAppLaunchedForTheFirstTime';
  static const isAppWasInBackground = 'isAppWasInBackground';
}
