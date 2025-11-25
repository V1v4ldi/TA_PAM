import 'package:tugas_akhir/data/services/db_service.dart';
import 'package:tugas_akhir/main.dart';
import 'package:flutter/material.dart';

class SessionCheck {
  final AuthService _authService;

  SessionCheck(this._authService);

  Future<bool> sessionCheck() async {
    final bool hasSession = await _authService.sessionCheck();
    if (hasSession == false) {
      navKey.currentState!.pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
      return false;
    }
    return true;
  }
}
