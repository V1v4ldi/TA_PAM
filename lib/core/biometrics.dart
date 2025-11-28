import 'package:local_auth/local_auth.dart';

final _auth = LocalAuthentication();

class Biometrics {
  Future<bool> hasBiometric() async {
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authWBiometric() async {
    final isAuthAvailable = await hasBiometric();

    if (!isAuthAvailable) {
      return false;
    }
    try {
      return await _auth.authenticate(
        localizedReason: "Autentikasi Dengan Fingerprint Untuk Melakukan Login",
        biometricOnly: true,
      );
    } catch (e) {
      return false;
    }
  }
}
