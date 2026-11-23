import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Map<String, dynamic>> _sales = [];
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    final rows = await db.query('sales', orderBy: 'id DESC');
    if (mounted) setState(() => _sales = rows);
  }

  Future<void> _addSale() async {
    final title = _titleCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (title.isEmpty || amount <= 0) return;
    final db = await DatabaseService.db;
    await db.insert('sales', {'title': title, 'amount': amount, 'date': DateTime.now().toString()});
    _titleCtrl.clear();
    _amountCtrl.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('المبيعات 🛒', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        const Text('فاتورة جديدة / بيع سريع', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        TextField(controller: _titleCtrl, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'اسم المنتج / الوصف - مثال: شاحن', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'المبلغ', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _addSale, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26A69A), minimumSize: const Size(double.infinity, 50)), child: const Text('إتمام البيع السريع', style: TextStyle(color: Colors.white))),
        const SizedBox(height: 16),
        const Text('سجل الفواتير', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        ..._sales.map((s) => Card(child: ListTile(title: Text(s['title'], textAlign: TextAlign.right), subtitle: Text('${s['amount']} جنيه', textAlign: TextAlign.right)))),
        if (_sales.isEmpty) const Text('لسه مفيش مبيعات', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }
}
