import 'package:get/get.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav_binding.dart';
import 'package:mybalance/app/ui/pages/about/about_page.dart';
import 'package:mybalance/app/ui/pages/editpassword/editpassword_page.dart';
import 'package:mybalance/app/ui/pages/editprofile/editprofile_page.dart';
import 'package:mybalance/app/ui/pages/history/history_binding.dart';
import 'package:mybalance/app/ui/pages/history/history_page.dart';
import 'package:mybalance/app/ui/pages/home/home_binding.dart';
import 'package:mybalance/app/ui/pages/home/home_page.dart';
import 'package:mybalance/app/ui/pages/income/income_page.dart';
import 'package:mybalance/app/ui/pages/login/login_page.dart';
import 'package:mybalance/app/ui/pages/main/main_page.dart';
import 'package:mybalance/app/ui/pages/outcome/outcome_page.dart';
import 'package:mybalance/app/ui/pages/profile/profile_page.dart';
import 'package:mybalance/app/ui/pages/register/register_page.dart';
import 'package:mybalance/app/ui/pages/reports/reports_binding.dart';
import 'package:mybalance/app/ui/pages/reports/reports_page.dart';
import 'package:mybalance/app/ui/pages/settings/settings_page.dart';

class AppRoutes {
  static const String about = '/about';
  static const String editPassword = '/edit-password';
  static const String editProfile = '/edit-profile';
  static const String history = '/history';
  static const String home = '/home';
  static const String income = '/income';
  static const String login = '/login';
  static const String main = '/main';
  static const String outcome = '/outcome';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String checkToken = '/check-token';

  static List<GetPage> routes = [
    GetPage(name: about, page: () => const AboutPage()),
    GetPage(name: editPassword, page: () => const EditpasswordPage()),
    GetPage(name: editProfile, page: () => const EditprofilePage()),
    GetPage(name: history, page: () => const HistoryPage()),
    GetPage(
        name: home,
        page: () => const HomePage(),
        bindings: [HomeBinding(), BottomNavBinding()]),
    GetPage(name: income, page: () => const IncomePage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: main, page: () => MainPage(), bindings: [
      BottomNavBinding(),
      HomeBinding(),
      ReportsBinding(),
      HistoryBinding()
    ]),
    GetPage(name: outcome, page: () => const OutcomePage()),
    GetPage(name: profile, page: () => const ProfilePage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: reports, page: () => const ReportsPage()),
    GetPage(name: settings, page: () => const SettingsPage()),
  ];
}
