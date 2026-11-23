import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'security/lock_screen.dart';

void main() => runApp(const FazlakaApp());

class FazlakaApp extends StatelessWidget {
  const FazlakaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fazlaka Pay',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFE8F5F2)),
      home: const LockScreen(nextScreen: DashboardScreen()),
    );
  }
}
