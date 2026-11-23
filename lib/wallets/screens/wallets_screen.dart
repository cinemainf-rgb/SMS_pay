import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});
  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  List<Map<String, dynamic>> _wallets = [];
  final _amountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    var rows = await db.query('wallets');
    if (rows.isEmpty) {
      final defaults = [
        {'name': 'نقدية (كاش الدرج)', 'balance': 1467594.6},
        {'name': 'الخزنة الرئيسية', 'balance': 0.0},
        {'name': 'إنستاباي', 'balance': 200.0},
        {'name': 'فودافون كاش', 'balance': 0.0},
        {'name': 'محفظة فوري', 'balance': 0.0},
      ];
      for (var w in defaults) await db.insert('wallets', w);
      rows = await db.query('wallets');
    }
    if (mounted) setState(() => _wallets = rows);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('المحافظ والخزنة 💳', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        ..._wallets.map((w) => Card(
          child: ListTile(
            title: Text(w['name'], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('الرصيد: ${w['balance']}', textAlign: TextAlign.right),
          ),
        )),
        const SizedBox(height: 16),
        const Text('تحويل بين الخزائن 💸', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'المبلغ المراد تحويله', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC9A227), minimumSize: const Size(double.infinity, 50)), child: const Text('تحويل', style: TextStyle(color: Colors.white))),
        const SizedBox(height: 16),
        const Text('كشف الحساب', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const Text('هنا هيظهر كل التحويلات والمعاملات', style: TextStyle(color: Colors.grey), textAlign: TextAlign.right),
      ],
    );
  }
}
