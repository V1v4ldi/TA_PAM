import 'package:hive/hive.dart';
import 'package:tugas_akhir/data/models/user_setting_models.dart';

class CacheService {
  static const String boxName = 'appSettings';

  Future<AppSettings> loadSettings() async {
    final box = await Hive.openBox(boxName);
    final raw = box.get('settings');

    if (raw != null && raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      return AppSettings.fromMap(map);
    }
    return AppSettings(currency: 'USD', timezone: 'UTC');
  }

  Future<void> saveSettings(AppSettings settings) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.put('settings', settings.toMap());
    } catch (e) {
      throw Exception("Gagal Update Settings");
    }
  }
}
