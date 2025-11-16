import 'package:tugas_akhir/data/models/user_setting_models.dart';
import 'package:tugas_akhir/data/services/cache_service.dart';

class UserRepositories {
  final CacheService _service;

  AppSettings settings = AppSettings(currency: "USD", timezone: "UTC");

  UserRepositories(this._service);

  Future<AppSettings> loadSettings() async {
    settings = await _service.loadSettings();
    return settings;
  }

  Future<AppSettings> updateCurrency(String currency) async {
    settings.currency = currency;
    await _service.saveSettings(settings);
    return settings;
  }

  Future<AppSettings> updateTimezone(String timezone) async {
    settings.timezone = timezone;
    await _service.saveSettings(settings);
    return settings;
  }
}
