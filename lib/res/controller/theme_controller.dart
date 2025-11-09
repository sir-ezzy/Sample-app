import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {
  final _themeMode = ThemeMode.light.obs;
  final box = Hive.box('local');

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    String? savedTheme = box.get("themeMode");
    if (savedTheme == "dark") {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }

    setSystemUIOverlay(_themeMode.value);
  }

  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
      box.put("themeMode", "dark");
    } else {
      _themeMode.value = ThemeMode.light;
      box.put("themeMode", "light");
    }

    setSystemUIOverlay(_themeMode.value);

    update();
  }

  void setSystemUIOverlay(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }
}
