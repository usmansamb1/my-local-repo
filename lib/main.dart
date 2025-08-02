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
import 'screens/wallet/invoices_screen.dart';
import 'screens/wallet/invoice_details_screen.dart';
import 'screens/wallet/add_balance_screen.dart';
import 'screens/wallet/payment_methods_screen.dart';
import 'screens/wallet/transaction_details_screen.dart';
import 'screens/vehicles/vehicles_screen.dart';
import 'screens/vehicles/vehicle_reports_screen.dart';
import 'screens/vehicles/add_vehicle_screen.dart';
import 'models/invoice.dart';
import 'models/transaction.dart';
import 'models/vehicle.dart';

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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Constants.loginRoute:
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case Constants.registerRoute:
            return MaterialPageRoute(builder: (context) => const RegisterScreen());
          case Constants.forgotPasswordRoute:
            return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
          case Constants.mainRoute:
            return MaterialPageRoute(builder: (context) => const MainScreen());
          case Constants.stationsMapRoute:
            return MaterialPageRoute(builder: (context) => const StationsMapScreen());
          case Constants.scanCodeRoute:
            return MaterialPageRoute(builder: (context) => const ScanCodeScreen());
          case Constants.fuelAppQuickRoute:
            return MaterialPageRoute(builder: (context) => const FuelAppQuickScreen());
          case Constants.invoicesRoute:
            return MaterialPageRoute(builder: (context) => const InvoicesScreen());
          case Constants.invoiceDetailsRoute:
            final invoice = settings.arguments as Invoice;
            return MaterialPageRoute(
              builder: (context) => InvoiceDetailsScreen(invoice: invoice),
            );
          case Constants.addBalanceRoute:
            return MaterialPageRoute(builder: (context) => const AddBalanceScreen());
          case Constants.paymentMethodsRoute:
            return MaterialPageRoute(builder: (context) => const PaymentMethodsScreen());
          case Constants.transactionDetailsRoute:
            final transaction = settings.arguments as Transaction;
            return MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(transaction: transaction),
            );
          case Constants.vehiclesRoute:
            return MaterialPageRoute(builder: (context) => const VehiclesScreen());
          case Constants.vehicleReportsRoute:
            final vehicle = settings.arguments as Vehicle;
            return MaterialPageRoute(
              builder: (context) => VehicleReportsScreen(vehicle: vehicle),
            );
          case Constants.addVehicleRoute:
            return MaterialPageRoute(builder: (context) => const AddVehicleScreen());
          default:
            return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
      },
    );
  }
}
