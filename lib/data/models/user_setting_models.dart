class AppSettings {
  String currency;
  String timezone;

  AppSettings({
    required this.currency,
    required this.timezone,
  });

  // Encode/decode ke Map untuk Hive/SharedPreferences
  Map<String, dynamic> toMap() => {
    'currency': currency,
    'timezone': timezone,
  };

  factory AppSettings.fromMap(Map<String, dynamic> map) => AppSettings(
    currency: map['currency'] ?? 'USD',
    timezone: map['timezone'] ?? 'UTC',
  );
}