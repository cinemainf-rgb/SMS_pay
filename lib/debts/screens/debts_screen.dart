import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});
  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  List<Map<String, dynamic>> _debts = [];
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    final rows = await db.query('debts', orderBy: 'id DESC');
    if (mounted) setState(() => _debts = rows);
  }

  Future<void> _add() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (name.isEmpty || amount <= 0) return;
    final db = await DatabaseService.db;
    await db.insert('debts', {'customer': name, 'phone': phone, 'amount': amount});
    _nameCtrl.clear(); _phoneCtrl.clear(); _amountCtrl.clear();
    _load();
  }

  Future<void> _pay(int id) async {
    final db = await DatabaseService.db;
    await db.delete('debts', where: 'id = ?', whereArgs: [id]);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('الديون 👥', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        const Text('دين جديد', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        TextField(controller: _nameCtrl, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'اسم الزبون', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'رقم التليفون', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'المبلغ', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _add, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB2DFDB), minimumSize: const Size(double.infinity, 50)), child: const Text('حفظ دين', style: TextStyle(color: Color(0xFF0F3D3A)))),
        const SizedBox(height: 16),
        const Text('العملاء / الديون', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        ..._debts.map((d) => Card(
          child: ListTile(
            title: Text(d['customer'], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${d['phone']} - ${d['amount']} جنيه', textAlign: TextAlign.right),
            trailing: TextButton(onPressed: () => _pay(d['id']), child: const Text('سداد ✅')),
          ),
        )),
        if (_debts.isEmpty) const Text('مفيش ديون', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }
}
