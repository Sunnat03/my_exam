import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteService {
  static final remoteConfig = FirebaseRemoteConfig.instance;

  static final Map<String, dynamic> availableBackgroundColors = {
    "red": Colors.red,
    "yellow": Colors.yellow,
    "blue": Colors.blue,
    "green": Colors.green,
    "white": Colors.white
  };

  static String backgroundColor = "blue";

  static Future<void> initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 20),
      // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
              20), // fetch parameters will be cached for a maximum of 1 hour
    ));

    await remoteConfig.setDefaults(const {
      "background_color": "blue",

    });
    await fetchConfig();
  }

  static Future<void> fetchConfig() async {
    await remoteConfig.fetchAndActivate().then((value) => {
          backgroundColor =
              remoteConfig.getString('background_color').isNotEmpty
                  ? remoteConfig.getString('background_color')
                  : "blue",
          debugPrint("Remote config is worked: $value")
        },
    );
  }
}
