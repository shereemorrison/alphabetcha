import 'package:alphabetcha/components/cards/game_card.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerSetupForm extends StatelessWidget {
  final TextEditingController nameController;
  final int computerPlayers;
  final Function(int) onComputerPlayersChanged;

  const PlayerSetupForm({
    Key? key,
    required this.nameController,
    required this.computerPlayers,
    required this.onComputerPlayersChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          Text('Computer Players',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('Add AI opponents: $computerPlayers')),
              Row(
                children: [
                  IconButton(
                    onPressed: computerPlayers > 0
                        ? () => onComputerPlayersChanged(computerPlayers - 1)
                        : null,
                    icon: Icon(Icons.remove_circle),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text('$computerPlayers',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: computerPlayers < 4
                        ? () => onComputerPlayersChanged(computerPlayers + 1)
                        : null,
                    icon: Icon(Icons.add_circle),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GameSettingsForm extends StatelessWidget {
  final int numberOfRounds;
  final int timePerRound;
  final Function(int) onRoundsChanged;
  final Function(int) onTimeChanged;

  const GameSettingsForm({
    Key? key,
    required this.numberOfRounds,
    required this.timePerRound,
    required this.onRoundsChanged,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSliderSetting(
            context,
            'Number of Rounds',
            numberOfRounds.toDouble(),
            1,
            10,
            (value) => onRoundsChanged(value.round()),
            '$numberOfRounds rounds',
          ),
          const SizedBox(height: 20),
          _buildSliderSetting(
            context,
            'Time per Round',
            timePerRound.toDouble(),
            30,
            300,
            (value) => onTimeChanged(value.round()),
            '${timePerRound ~/ 60}:${(timePerRound % 60).toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    BuildContext context,
    String title,
    double value,
    double min,
    double max,
    Function(double) onChanged,
    String displayValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}

class CategoriesForm extends StatelessWidget {
  final List<String> selectedCategories;
  final Function(List<String>) onCategoriesChanged;

  const CategoriesForm({
    Key? key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return GameCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Categories (${selectedCategories.length}/8)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: gameProvider.defaultCategories.map((category) {
                  final isSelected = selectedCategories.contains(category.name);
                  return FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(category.name),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      final newCategories =
                          List<String>.from(selectedCategories);
                      if (selected) {
                        if (newCategories.length < 8) {
                          newCategories.add(category.name);
                        }
                      } else {
                        newCategories.remove(category.name);
                      }
                      onCategoriesChanged(newCategories);
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
