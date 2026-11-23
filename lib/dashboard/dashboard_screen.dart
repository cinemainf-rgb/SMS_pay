import 'package:flutter/material.dart';
import '../security/lock_screen.dart';
import '../machines/screens/machines_screen.dart';
import '../wallets/screens/wallets_screen.dart';
import '../inventory/screens/inventory_screen.dart';
import '../sales/screens/sales_screen.dart';
import '../debts/screens/debts_screen.dart';
import '../maintenance/screens/maintenance_screen.dart';
import '../reports/screens/reports_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;

  void _go(int i) {
    Navigator.pop(context);
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F3D3A),
          title: const Text('Fazlaka Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
                color: const Color(0xFF0F3D3A),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fazlaka Pay', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('فزلكة', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _drawerItem(Icons.home, 'لوحة التحكم', () => _go(0)),
                    _drawerItem(Icons.atm, 'المكن', () => _go(1)),
                    _drawerItem(Icons.account_balance_wallet, 'المحافظ', () => _go(2)),
                    _drawerItem(Icons.inventory_2, 'المخزون', () => _go(3)),
                    _drawerItem(Icons.shopping_cart, 'المبيعات', () => _go(4)),
                    _drawerItem(Icons.people, 'الديون', () => _go(5)),
                    _drawerItem(Icons.build, 'الصيانة', () => _go(6)),
                    _drawerItem(Icons.bar_chart, 'التقارير', () => _go(7)),
                    const Divider(),
                    _drawerItem(Icons.lock_clock, 'تقفيل اليوم', () => _go(7)),
                    _drawerItem(Icons.archive, 'الأرشيف', () => _go(7)),
                    _drawerItem(Icons.search, 'البحث', () => _go(0)),
                    _drawerItem(Icons.backup, 'النسخ الاحتياطي', () => _go(0)),
                    _drawerItem(Icons.file_download, 'تصدير البيانات', () => _go(7)),
                    _drawerItem(Icons.settings, 'الإعدادات', () => _go(0)),
                    _drawerItem(Icons.lock, 'قفل البرنامج', () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LockScreen(nextScreen: DashboardScreen())));
                    }, isRed: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: _page(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          selectedItemColor: const Color(0xFF0F3D3A),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (i) => setState(() => _index = i),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.atm), label: 'المكن'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'المحافظ'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'المخزون'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'المبيعات'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'الديون'),
            BottomNavigationBarItem(icon: Icon(Icons.build), label: 'الصيانة'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'التقارير'),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap, {bool isRed = false}) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20, color: isRed ? Colors.red : const Color(0xFF0F3D3A)),
      title: Text(title, style: TextStyle(color: isRed ? Colors.red : Colors.black87, fontWeight: isRed ? FontWeight.bold : FontWeight.normal)),
      onTap: onTap,
    );
  }

  Widget _page() {
    switch (_index) {
      case 0: return _home();
      case 1: return const MachinesScreen();
      case 2: return const WalletsScreen();
      case 3: return const InventoryScreen();
      case 4: return const SalesScreen();
      case 5: return const DebtsScreen();
      case 6: return const MaintenanceScreen();
      default: return const ReportsScreen();
    }
  }

  Widget _home() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(children: [Expanded(child: _card('النقدية (الدرج)', '1,467,594.6')), const SizedBox(width: 8), Expanded(child: _card('ربح اليوم', '0'))]),
        const SizedBox(height: 8),
        Row(children: [Expanded(child: _card('المبيعات', '0')), const SizedBox(width: 8), Expanded(child: _card('الديون', '0'))]),
        const SizedBox(height: 8),
        _card('عدد العمليات', '6'),
      ],
    );
  }

  Widget _card(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
