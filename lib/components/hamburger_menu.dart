import 'package:alphabetcha/components/game_controls_section.dart';
import 'package:alphabetcha/components/manu_drawer_header.dart';
import 'package:alphabetcha/models/menu_item.dart';
import 'package:alphabetcha/screens/settings_screen.dart';
import 'package:alphabetcha/utils/menu_dialogs.dart';
import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  final bool showGameControls;

  const HamburgerMenu({
    Key? key,
    this.showGameControls = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            MenuDrawerHeader(),
            MenuItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => _navigateToSettings(context),
            ),
            if (showGameControls) ...[
              const Divider(),
              GameControlsSection(),
            ],
            const Divider(),
            MenuItem(
              icon: Icons.help_outline,
              title: 'How to Play',
              onTap: () => MenuDialogs.showHowToPlay(context),
            ),
            MenuItem(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () => MenuDialogs.showAbout(context),
            ),
            const Divider(),
            MenuItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () => MenuDialogs.goHome(context),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }
}
