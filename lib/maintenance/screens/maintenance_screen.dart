import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});
  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  List<Map<String, dynamic>> _items = [];
  final _deviceCtrl = TextEditingController();
  String _status = 'قيد الإصلاح';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    final rows = await db.query('maintenance', orderBy: 'id DESC');
    if (mounted) setState(() => _items = rows);
  }

  Future<void> _add() async {
    final device = _deviceCtrl.text.trim();
    if (device.isEmpty) return;
    final db = await DatabaseService.db;
    await db.insert('maintenance', {'device': device, 'status': _status});
    _deviceCtrl.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('الصيانة 🔧', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        TextField(controller: _deviceCtrl, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'اسم الجهاز - مثال: موبايل سامسونج', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
          items: ['قيد الإصلاح', 'تم الإصلاح', 'تم التسليم'].map((e) => DropdownMenuItem(value: e, child: Text(e, textAlign: TextAlign.right))).toList(),
          onChanged: (v) => setState(() => _status = v!),
        ),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _add, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26A69A), minimumSize: const Size(double.infinity, 50)), child: const Text('إضافة جهاز', style: TextStyle(color: Colors.white))),
        const SizedBox(height: 16),
        const Text('الأجهزة / حالات الإصلاح', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        ..._items.map((m) => Card(child: ListTile(title: Text(m['device'], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(m['status'], textAlign: TextAlign.right)))),
        if (_items.isEmpty) const Text('مفيش أجهزة صيانة', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }
}
