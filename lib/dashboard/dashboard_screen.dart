import 'package:flutter/material.dart';
import '../security/lock_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;

  void _go(int tabIndex) {
    Navigator.pop(context);
    setState(() => _index = tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D3A),
        title: const Text('Fazlaka Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0F3D3A)),
              child: Text('Fazlaka Pay\nفزلكة', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            ListTile(title: const Text('لوحة التحكم', textAlign: TextAlign.right), onTap: () => _go(0)),
            ListTile(title: const Text('المكن', textAlign: TextAlign.right), onTap: () => _go(1)),
            ListTile(title: const Text('المحافظ', textAlign: TextAlign.right), onTap: () => _go(2)),
            ListTile(title: const Text('المخزون', textAlign: TextAlign.right), onTap: () => _go(3)),
            ListTile(title: const Text('المبيعات', textAlign: TextAlign.right), onTap: () => _go(4)),
            ListTile(title: const Text('الديون', textAlign: TextAlign.right), onTap: () => _go(5)),
            ListTile(title: const Text('المصروفات', textAlign: TextAlign.right), onTap: () => _go(5)),
            ListTile(title: const Text('الصيانة', textAlign: TextAlign.right), onTap: () => _go(6)),
            ListTile(title: const Text('التقارير', textAlign: TextAlign.right), onTap: () => _go(7)),
            ListTile(title: const Text('تقفيل اليوم', textAlign: TextAlign.right), onTap: () => _go(7)),
            ListTile(title: const Text('الأرشيف', textAlign: TextAlign.right), onTap: () => _go(7)),
            ListTile(title: const Text('البحث', textAlign: TextAlign.right), onTap: () => _go(0)),
            ListTile(title: const Text('النسخ الاحتياطي', textAlign: TextAlign.right), onTap: () => _go(0)),
            ListTile(title: const Text('تصدير البيانات', textAlign: TextAlign.right), onTap: () => _go(7)),
            ListTile(title: const Text('الإعدادات', textAlign: TextAlign.right), onTap: () => _go(0)),
            ListTile(
              title: const Text('قفل البرنامج 🔒', textAlign: TextAlign.right, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LockScreen(nextScreen: DashboardScreen())));
              },
            ),
          ],
        ),
      ),
      body: _page(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: const Color(0xFF0F3D3A),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Text('🏠', style: TextStyle(fontSize: 22)), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Text('🏧', style: TextStyle(fontSize: 22)), label: 'المكن'),
          BottomNavigationBarItem(icon: Text('💳', style: TextStyle(fontSize: 22)), label: 'المحافظ'),
          BottomNavigationBarItem(icon: Text('📦', style: TextStyle(fontSize: 22)), label: 'المخزون'),
          BottomNavigationBarItem(icon: Text('🛒', style: TextStyle(fontSize: 22)), label: 'المبيعات'),
          BottomNavigationBarItem(icon: Text('👥', style: TextStyle(fontSize: 22)), label: 'الديون'),
          BottomNavigationBarItem(icon: Text('🔧', style: TextStyle(fontSize: 22)), label: 'الصيانة'),
          BottomNavigationBarItem(icon: Text('📊', style: TextStyle(fontSize: 22)), label: 'التقارير'),
        ],
      ),
    );
  }

  Widget _page() {
    switch (_index) {
      case 0: return _home();
      case 1: return _section('المكن 🏧', ['الرصيد', 'العمليات', 'الأرباح']);
      case 2: return _section('المحافظ 💳', ['المحافظ', 'التحويلات', 'كشف الحساب']);
      case 3: return _section('المخزون 📦', ['المنتجات', 'الكميات', 'التنبيهات']);
      case 4: return _section('المبيعات 🛒', ['فاتورة جديدة', 'بيع سريع', 'سجل الفواتير']);
      case 5: return _section('الديون 👥', ['العملاء', 'الديون', 'السداد']);
      case 6: return _section('الصيانة 🔧', ['الأجهزة', 'حالات الإصلاح']);
      default: return _section('التقارير 📊', ['يومية', 'أسبوعية', 'شهرية', 'سنوية']);
    }
  }

  Widget _home() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(children: [Expanded(child: _card('النقدية (الدرج)', '1,467,594.6')), Expanded(child: _card('ربح اليوم', '0'))]),
          Row(children: [Expanded(child: _card('المبيعات', '0')), Expanded(child: _card('الديون', '0'))]),
          _card('عدد العمليات', '6'),
        ],
      ),
    );
  }

  Widget _section(String title, List<String> items) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        ...items.map((e) => Card(child: ListTile(title: Text(e, textAlign: TextAlign.right), trailing: const Icon(Icons.arrow_back_ios, size: 14)))),
      ],
    );
  }

  Widget _card(String title, String value) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
