import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

/// Simple cubit that stores ThemeMode in a Hive box so it persists across launches.
class ThemeCubit extends Cubit<ThemeMode> {
  final Box _settings;

  ThemeCubit(this._settings, ThemeMode initialMode) : super(initialMode);

  static ThemeMode _fromString(String? s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  void _save(ThemeMode mode) => _settings.put('themeMode', _toString(mode));

  /// Toggle strictly between light and dark (ignores system).
  void toggle() {
    final next = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _save(next);
    emit(next);
  }

  /// Optional: set explicit mode (light/dark/system)
  void setMode(ThemeMode mode) {
    _save(mode);
    emit(mode);
  }

  /// Helper to read initial mode from settings.
  static ThemeMode readInitial(Box box) =>
      _fromString(box.get('themeMode') as String?);
}
