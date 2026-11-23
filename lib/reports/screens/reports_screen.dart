import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  double _salesTotal = 0;
  double _expensesTotal = 0;
  int _salesCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    final sales = await db.query('sales');
    final expenses = await db.query('expenses');
    double s = 0;
    for (var r in sales) s += (r['amount'] as num).toDouble();
    double e = 0;
    for (var r in expenses) e += (r['amount'] as num).toDouble();
    if (mounted) setState(() { _salesTotal = s; _expensesTotal = e; _salesCount = sales.length; });
  }

  @override
  Widget build(BuildContext context) {
    final profit = _salesTotal - _expensesTotal;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('التقارير 📊', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: _card('مبيعات اليوم', '$_salesTotal')), Expanded(child: _card('صافي الربح', '$profit'))]),
        Row(children: [Expanded(child: _card('المصروفات', '$_expensesTotal')), Expanded(child: _card('عدد العمليات', '$_salesCount'))]),
        const SizedBox(height: 16),
        const Text('يومية / أسبوعية / شهرية / سنوية', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const Text('التقرير ده بيتحسب من المبيعات والمصروفات الحقيقية', style: TextStyle(color: Colors.grey), textAlign: TextAlign.right),
        const SizedBox(height: 16),
        const Text('تقفيل اليوم', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _load, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26A69A), minimumSize: const Size(double.infinity, 50)), child: const Text('تحديث / تقفيل اليوم', style: TextStyle(color: Colors.white))),
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
