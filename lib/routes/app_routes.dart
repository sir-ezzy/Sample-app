import 'package:get/get.dart';
import 'package:sample/pages/home.dart';

class AppRoutes {
  static const String splashPage = '/splash';

  static List<GetPage> pages = [
    GetPage(name: splashPage, page: () => HomeScreen()),
  ];
}
