import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/middleware/check-token.dart';
import 'package:mybalance/app/routes/app_routes.dart';
import 'package:mybalance/app/utils/color.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Balance',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.secondary,
        fontFamily: 'DM Sans',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.checkToken, // Set route ke middleware
      getPages: [
        ...AppRoutes.routes,
        GetPage(
          name: AppRoutes.checkToken,
          page: () => const CheckTokenPage(),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
