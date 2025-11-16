import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/user_setting_models.dart';
import 'package:tugas_akhir/data/repositories/user_repositories.dart';

class SettingsViewModel extends ChangeNotifier {
  final UserRepositories _userRepositories;

  AppSettings settings = AppSettings(currency: "USD", timezone: "UTC");

  SettingsViewModel(this._userRepositories);

  Future<void> loadSettings() async {
    settings = await _userRepositories.loadSettings();
    notifyListeners();
  }

  Future<void> updateCurrency(String currency) async {
    await _userRepositories.updateCurrency(currency);
    settings.currency = currency;
    notifyListeners();
  }

  Future<void> updateTimezone(String timezone) async {
    await _userRepositories.updateTimezone(timezone);
    settings.timezone = timezone;
    notifyListeners();
  }
}
