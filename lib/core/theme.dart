import 'package:flutter/material.dart';

// Definisi semua warna dalam sistem desain
class AppColors {
  // --- Primary Colors ---
  static const Color purple300 = Color(0xFFC084FC);
  static const Color pink300 = Color(0xFFF9A8D4);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color pink600 = Color(0xFFEC4899);
  
  // --- Background Colors ---
  static const Color darkSlate900 = Color(0xFF0F172A);
  static const Color purple900 = Color(0xFF581C87);

  // --- Text Colors ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey300 = Color(0xFFD1D5DB); // Secondary text (unselected)
  static const Color grey400 = Color(0xFF9CA3AF); // Tertiary text (dates, time)

  // --- Status Colors ---
  static const Color green300 = Color(0xFF86EFAC); // Upcoming match badge
  static const Color red300 = Color(0xFFFCA5A5); // Finished match badge

  // --- Opacity Colors (Digunakan untuk BoxDecoration/Container) ---
  static Color get blackOpacity40 => Colors.black.withOpacity(0.4); // Header background
  static Color get whiteOpacity10 => Colors.white.withOpacity(0.1); // Card/Border background
  static Color get whiteOpacity20 => Colors.white.withOpacity(0.2); // Icon containers
  static Color get greenOpacity20 => green300.withOpacity(0.2); // Upcoming badge background
  static Color get redOpacity20 => red300.withOpacity(0.2); // Finished badge background
  static Color get shadowOpacity30 => purple600.withOpacity(0.3); // Default shadow

  // --- Gradient Definitions ---
  static const LinearGradient mainBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      darkSlate900,
      purple900,
      darkSlate900,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient purplePinkGradient = LinearGradient(
    colors: [purple600, pink600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient titleShaderGradient = LinearGradient(
    colors: [purple300, pink300],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Contoh gradient lainnya untuk Badges (diambil dari DS)
  static const LinearGradient laLigaBadgeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
}
  // Tambahkan gradient kompetisi/menu lainnya di sini sesuai DS