library app_restart_observer;


import 'package:app_restart_observer/enum.dart';
import 'package:app_restart_observer/hive_utils.dart';
import 'package:app_restart_observer/model.dart';
import 'package:flutter/material.dart';
export 'package:app_restart_observer/extensions.dart';

class AppRestartObserver with WidgetsBindingObserver {
  static AppRestartObserver? _instance;
  AppRestartData? _data;

  AppRestartData get data {
    if (_data == null) {
      throw 'App Restart Observer is not initialized.';
    }

    return _data!;
  }

  AppRestartObserver._internal() {
    _instance = this;
  }

  factory AppRestartObserver() => _instance ?? AppRestartObserver._internal();

  Future<void> initialize() async {
    await HiveUtils().init();

    AppRestartData data = await getAppRestartData();

    _data = AppRestartData(isRestarted: data.isRestarted, appRestartType: data.appRestartType);

    if (_data!.isRestarted) {
      HiveUtils().setBoolean(HiveStoreKey.isAppWasInBackground, false);
    } else {
      HiveUtils().setBoolean(HiveStoreKey.isAppLaunchedForTheFirstTime, false);
    }

    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      HiveUtils().setBoolean(HiveStoreKey.isAppWasInBackground, false);
    } else if (state == AppLifecycleState.paused) {
      HiveUtils().setBoolean(HiveStoreKey.isAppWasInBackground, true);
    } else if (state == AppLifecycleState.inactive) {
      HiveUtils().setBoolean(HiveStoreKey.isAppWasInBackground, true);
    }
  }
}

Future<AppRestartData> getAppRestartData() async {
  AppRestartData appRestartData = AppRestartData(isRestarted: false);

  if (!(await HiveUtils().getBoolean(HiveStoreKey.isAppLaunchedForTheFirstTime) ?? true)) {
      appRestartData.isRestarted = true;
    if (await HiveUtils().getBoolean(HiveStoreKey.isAppWasInBackground) ?? false) {
      appRestartData.appRestartType = AppRestartType.userIntended;
    } else {
      appRestartData.appRestartType = AppRestartType.systemCrash;
    }
  }

  return appRestartData;
}
