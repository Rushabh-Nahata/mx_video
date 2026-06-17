import 'package:flutter/material.dart';

/// All brand and semantic colors for MX Video.
/// Reference these instead of hard-coding color literals.
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1565C0);       // deep blue
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color accent = Color(0xFF00B0FF);         // cyan accent

  // ── Dark surface palette ───────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkSurfaceVariant = Color(0xFF1E1E1E);
  static const Color darkDivider = Color(0xFF2A2A2A);

  // ── Light surface palette ──────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEEEEE);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFF606060);
  static const Color textPrimaryLight = Color(0xFF0D0D0D);
  static const Color textSecondaryLight = Color(0xFF616161);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);
  static const Color error = Color(0xFFE53935);

  // ── Player ─────────────────────────────────────────────────────────────────
  static const Color playerBackground = Color(0xFF000000);
  static const Color playerControlsTint = Color(0xFFFFFFFF);
  static const Color seekBarActive = Color(0xFF1E88E5);
  static const Color seekBarBuffer = Color(0x661E88E5);
  static const Color seekBarTrack = Color(0x33FFFFFF);

  // ── Transfer ───────────────────────────────────────────────────────────────
  static const Color transferSend = Color(0xFF1E88E5);
  static const Color transferReceive = Color(0xFF43A047);
  static const Color transferFailed = Color(0xFFE53935);
}
