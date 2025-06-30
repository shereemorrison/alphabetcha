import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;
  double _timerVolume = 0.7;
  String _difficulty = 'Normal'; // Easy, Normal, Hard
  String _theme = 'System'; // Light, Dark, System
  bool _showHints = true;
  bool _autoSubmit = true;

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  double get timerVolume => _timerVolume;
  String get difficulty => _difficulty;
  String get theme => _theme;
  bool get showHints => _showHints;
  bool get autoSubmit => _autoSubmit;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _timerVolume = prefs.getDouble('timerVolume') ?? 0.7;
    _difficulty = prefs.getString('difficulty') ?? 'Normal';
    _theme = prefs.getString('theme') ?? 'System';
    _showHints = prefs.getBool('showHints') ?? true;
    _autoSubmit = prefs.getBool('autoSubmit') ?? true;

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('vibrationEnabled', _vibrationEnabled);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setDouble('timerVolume', _timerVolume);
    await prefs.setString('difficulty', _difficulty);
    await prefs.setString('theme', _theme);
    await prefs.setBool('showHints', _showHints);
    await prefs.setBool('autoSubmit', _autoSubmit);
  }

  void setSoundEnabled(bool value) {
    _soundEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  void setVibrationEnabled(bool value) {
    _vibrationEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  void setTimerVolume(double value) {
    _timerVolume = value;
    _saveSettings();
    notifyListeners();
  }

  void setDifficulty(String value) {
    _difficulty = value;
    _saveSettings();
    notifyListeners();
  }

  void setTheme(String value) {
    _theme = value;
    _saveSettings();
    notifyListeners();
  }

  void setShowHints(bool value) {
    _showHints = value;
    _saveSettings();
    notifyListeners();
  }

  void setAutoSubmit(bool value) {
    _autoSubmit = value;
    _saveSettings();
    notifyListeners();
  }

  void resetToDefaults() {
    _soundEnabled = true;
    _vibrationEnabled = true;
    _notificationsEnabled = true;
    _timerVolume = 0.7;
    _difficulty = 'Normal';
    _theme = 'System';
    _showHints = true;
    _autoSubmit = true;

    _saveSettings();
    notifyListeners();
  }
}
