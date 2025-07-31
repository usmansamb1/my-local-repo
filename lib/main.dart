import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/stations/stations_map_screen.dart';
import 'screens/scan/scan_code_screen.dart';
import 'screens/quick/fuelapp_quick_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      initialRoute: Constants.loginRoute,
      routes: {
        Constants.loginRoute: (context) => const LoginScreen(),
        Constants.registerRoute: (context) => const RegisterScreen(),
        Constants.forgotPasswordRoute: (context) => const ForgotPasswordScreen(),
        Constants.mainRoute: (context) => const MainScreen(),
        Constants.stationsMapRoute: (context) => const StationsMapScreen(),
        Constants.scanCodeRoute: (context) => const ScanCodeScreen(),
        Constants.fuelAppQuickRoute: (context) => const FuelAppQuickScreen(),
      },
    );
  }
}
