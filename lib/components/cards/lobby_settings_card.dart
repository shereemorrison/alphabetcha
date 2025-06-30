import 'package:alphabetcha/components/cards/game_card.dart';
import 'package:alphabetcha/models/game_models.dart';
import 'package:flutter/material.dart';

class LobbySettingsCard extends StatelessWidget {
  final GameSettings settings;

  const LobbySettingsCard({Key? key, required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSettingItem(
                  'Rounds',
                  '${settings.numberOfRounds}',
                  Icons.repeat,
                ),
              ),
              Expanded(
                child: _buildSettingItem(
                  'Time',
                  '${settings.timePerRound ~/ 60}:${(settings.timePerRound % 60).toString().padLeft(2, '0')}',
                  Icons.timer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Categories (${settings.categories.length})',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: settings.categories.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
