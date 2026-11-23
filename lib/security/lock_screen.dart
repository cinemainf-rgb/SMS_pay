import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'biometric_service.dart';

class LockScreen extends StatefulWidget {
  final Widget nextScreen;
  const LockScreen({super.key, required this.nextScreen});
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _pinCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _storage = const FlutterSecureStorage();
  String? _savedPin;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _savedPin = await _storage.read(key: 'fazlaka_pin');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _tryBiometric() async {
    final ok = await BiometricService.authenticate();
    if (!ok) {
      if (mounted) setState(() => _error = 'البصمة فشلت، جرب تاني');
      return;
    }
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => widget.nextScreen));
  }

  Future<void> _submit() async {
    final pin = _pinCtrl.text.trim();
    if (_savedPin == null) {
      if (pin.length < 4) { setState(() => _error = 'PIN 4 أرقام على الأقل'); return; }
      if (pin != _confirmCtrl.text.trim()) { setState(() => _error = 'الرمز غير متطابق'); return; }
      await _storage.write(key: 'fazlaka_pin', value: pin);
    } else {
      if (pin != _savedPin) { setState(() => _error = 'PIN غلط'); return; }
    }
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => widget.nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(backgroundColor: Color(0xFF0F3D3A), body: Center(child: CircularProgressIndicator(color: Colors.white)));
    final isSetup = _savedPin == null;
    return Scaffold(
      backgroundColor: const Color(0xFF0F3D3A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('Fazlaka', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic)),
                const Text('Fazlaka Pay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),
                const SizedBox(height: 40),
                if (_error != null) Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(controller: _pinCtrl, keyboardType: TextInputType.number, obscureText: true, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold), decoration: InputDecoration(hintText: '••••', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 20))),
                if (isSetup) ...[
                  const SizedBox(height: 16),
                  TextField(controller: _confirmCtrl, keyboardType: TextInputType.number, obscureText: true, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold), decoration: InputDecoration(hintText: 'تأكيد ••••', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 20))),
                ],
                const SizedBox(height: 30),
                SizedBox(width: double.infinity, height: 56, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26A69A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: _submit, child: Text(isSetup ? 'حفظ وفتح' : 'دخول', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)))),
                if (!isSetup) ...[
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB2DFDB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: _tryBiometric, icon: const Icon(Icons.fingerprint, size: 28, color: Color(0xFF0F3D3A)), label: const Text('دخول بالبصمة 👆', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F3D3A))))),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
