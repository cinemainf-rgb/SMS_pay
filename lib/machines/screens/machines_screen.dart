import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class MachinesScreen extends StatefulWidget {
  const MachinesScreen({super.key});
  @override
  State<MachinesScreen> createState() => _MachinesScreenState();
}

class _MachinesScreenState extends State<MachinesScreen> {
  List<Map<String, dynamic>> _machines = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    var rows = await db.query('machines');
    if (rows.isEmpty) {
      // أول مرة بس - المكن بتاعك
      final defaults = [
        {'name': 'فوري رئيسي', 'balance': 4121.5},
        {'name': 'فوري كروت', 'balance': 0.0},
        {'name': 'فوري كاش أوت', 'balance': 23000.0},
        {'name': 'موبايل', 'balance': 4121.5},
        {'name': 'بساطة', 'balance': 0.0},
        {'name': 'كاش مصر', 'balance': 1162.4},
      ];
      for (var m in defaults) await db.insert('machines', m);
      rows = await db.query('machines');
    }
    if (mounted) setState(() => _machines = rows);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('المكن 🏧', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        ..._machines.map((m) => Card(
          child: ListTile(
            title: Text(m['name'], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('الرصيد: ${m['balance']}', textAlign: TextAlign.right),
            trailing: const Text('العمليات / الأرباح', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        )),
      ],
    );
  }
}
