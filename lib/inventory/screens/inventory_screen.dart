import 'package:flutter/material.dart';
import '../../database/database_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Map<String, dynamic>> _products = [];
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _sellCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseService.db;
    final rows = await db.query('products', orderBy: 'id DESC');
    if (mounted) setState(() => _products = rows);
  }

  Future<void> _add() async {
    final name = _nameCtrl.text.trim();
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    final sell = double.tryParse(_sellCtrl.text.trim()) ?? 0;
    if (name.isEmpty) return;
    final db = await DatabaseService.db;
    await db.insert('products', {'name': name, 'qty': qty, 'buy': 0, 'sell': sell});
    _nameCtrl.clear(); _qtyCtrl.clear(); _sellCtrl.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('المخزون 📦', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 12),
        const Text('المنتجات', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        TextField(controller: _nameCtrl, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'اسم المنتج', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextField(controller: _qtyCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'الكمية', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: _sellCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'سعر البيع', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))),
        ]),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _add, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26A69A), minimumSize: const Size(double.infinity, 50)), child: const Text('إضافة منتج', style: TextStyle(color: Colors.white))),
        const SizedBox(height: 16),
        const Text('الكميات / التنبيهات', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        ..._products.map((p) => Card(
          child: ListTile(
            title: Text(p['name'], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('الكمية: ${p['qty']} - السعر: ${p['sell']}', textAlign: TextAlign.right),
            trailing: (p['qty'] as int) <= 2 ? const Text('⚠️ قرب يخلص', style: TextStyle(color: Colors.red, fontSize: 12)) : null,
          ),
        )),
        if (_products.isEmpty) const Text('المخزون فاضي', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }
}
