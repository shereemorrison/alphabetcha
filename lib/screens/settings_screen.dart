import 'package:alphabetcha/components/cards/settings_card.dart';
import 'package:alphabetcha/components/settings_section.dart';
import 'package:alphabetcha/components/settings_tiles.dart';
import 'package:alphabetcha/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsSection(title: 'Audio & Feedback'),
                SettingsCard(
                  children: [
                    SettingsSwitchTile(
                      title: 'Sound Effects',
                      subtitle: 'Play sound effects during gameplay',
                      icon: Icons.volume_up,
                      value: settings.soundEnabled,
                      onChanged: settings.setSoundEnabled,
                    ),
                    SettingsSwitchTile(
                      title: 'Vibration',
                      subtitle: 'Vibrate on interactions',
                      icon: Icons.vibration,
                      value: settings.vibrationEnabled,
                      onChanged: settings.setVibrationEnabled,
                    ),
                    SettingsSliderTile(
                      title: 'Timer Volume',
                      subtitle: 'Volume for countdown timer',
                      icon: Icons.timer,
                      value: settings.timerVolume,
                      onChanged: settings.setTimerVolume,
                      enabled: settings.soundEnabled,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SettingsSection(title: 'Gameplay'),
                SettingsCard(
                  children: [
                    SettingsDropdownTile(
                      title: 'Difficulty',
                      subtitle: 'AI validation strictness',
                      icon: Icons.tune,
                      value: settings.difficulty,
                      options: ['Easy', 'Normal', 'Hard'],
                      onChanged: settings.setDifficulty,
                    ),
                    SettingsSwitchTile(
                      title: 'Show Hints',
                      subtitle: 'Display helpful hints during gameplay',
                      icon: Icons.lightbulb_outline,
                      value: settings.showHints,
                      onChanged: settings.setShowHints,
                    ),
                    SettingsSwitchTile(
                      title: 'Auto Submit',
                      subtitle: 'Automatically submit when time runs out',
                      icon: Icons.send,
                      value: settings.autoSubmit,
                      onChanged: settings.setAutoSubmit,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SettingsSection(title: 'Appearance'),
                SettingsCard(
                  children: [
                    SettingsDropdownTile(
                      title: 'Theme',
                      subtitle: 'App appearance theme',
                      icon: Icons.palette,
                      value: settings.theme,
                      options: ['Light', 'Dark', 'System'],
                      onChanged: settings.setTheme,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SettingsSection(title: 'Notifications'),
                SettingsCard(
                  children: [
                    SettingsSwitchTile(
                      title: 'Push Notifications',
                      subtitle: 'Receive game notifications',
                      icon: Icons.notifications,
                      value: settings.notificationsEnabled,
                      onChanged: settings.setNotificationsEnabled,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _showResetConfirmation(context, settings),
                    icon: Icon(Icons.restore),
                    label: Text('Reset to Defaults'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Settings'),
          content: Text(
              'Are you sure you want to reset all settings to their default values?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                settings.resetToDefaults();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Settings reset to defaults')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
