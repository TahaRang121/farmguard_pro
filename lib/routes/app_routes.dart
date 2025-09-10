import 'package:flutter/material.dart';
import '../presentation/expert_consultation/expert_consultation.dart';
import '../presentation/farm_management/farm_management.dart';
import '../presentation/farm_dashboard/farm_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/crop_health_scanner/crop_health_scanner.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String expertConsultation = '/expert-consultation';
  static const String farmManagement = '/farm-management';
  static const String farmDashboard = '/farm-dashboard';
  static const String login = '/login-screen';
  static const String cropHealthScanner = '/crop-health-scanner';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    expertConsultation: (context) => const ExpertConsultation(),
    farmManagement: (context) => const FarmManagement(),
    farmDashboard: (context) => const FarmDashboard(),
    login: (context) => const LoginScreen(),
    cropHealthScanner: (context) => const CropHealthScanner(),
    // TODO: Add your other routes here
  };
}
