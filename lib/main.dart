import 'package:flutter/material.dart';
import 'package:infrawatch/theme.dart';
import 'package:infrawatch/services/auth_service.dart';
import 'package:infrawatch/services/monitoring_service.dart';
import 'package:infrawatch/screens/login_screen.dart';
import 'package:infrawatch/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await AuthService().loadUserData();
  await MonitoringService().loadAlertConfiguration();
  
  runApp(const InfraWatchApp());
}

class InfraWatchApp extends StatelessWidget {
  const InfraWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfraWatch - Infrastructure Monitoring',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: AuthService().isAuthenticated ? const MainScreen() : const LoginScreen(),
    );
  }
}
