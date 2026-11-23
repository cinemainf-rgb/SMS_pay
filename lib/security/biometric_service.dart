import 'package:flutter/services.dart';

class BiometricService {
  static const _channel = MethodChannel('fazlaka/biometric');

  // بصمة حقيقية - بتكلم الموبايل نفسه
  static Future<bool> authenticate() async {
    try {
      final ok = await _channel.invokeMethod<bool>('authenticate') ?? false;
      return ok;
    } catch (e) {
      return false;
    }
  }
}
