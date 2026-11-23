import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Map<String, dynamic>> _expenses = [];
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    final rows = await db.query('expenses', orderBy: 'id DESC');
    if (mounted) setState(() => _expenses = rows);
  }

  Future<void> _add() async {
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (amount <= 0) return;
    final db = await DatabaseService.db;
    await db.insert('expenses', {'amount': amount, 'note': _noteCtrl.text.trim(), 'date': DateTime.now().toString()});
    _amountCtrl.clear(); _noteCtrl.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('المصروفات 💸', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'المبلغ', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        TextField(controller: _noteCtrl, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'ملاحظات', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _add, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB2DFDB), minimumSize: const Size(double.infinity, 50)), child: const Text('حفظ مصروف', style: TextStyle(color: Color(0xFF0F3D3A)))),
        const SizedBox(height: 16),
        const Text('سجل المصروفات', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        ..._expenses.map((e) => Card(child: ListTile(title: Text(e['note'].toString().isEmpty ? 'مصروف' : e['note'], textAlign: TextAlign.right), subtitle: Text('${e['amount']} جنيه', textAlign: TextAlign.right)))),
        if (_expenses.isEmpty) const Text('مفيش مصروفات', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }
}
