import 'package:alphabetcha/components/cards/game_card.dart';
import 'package:alphabetcha/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    onSelected: (selected) =>
                        _handleCategorySelection(selected, category.name),
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

  void _handleCategorySelection(bool selected, String categoryName) {
    final newCategories = List<String>.from(selectedCategories);
    if (selected) {
      if (newCategories.length < 8) {
        newCategories.add(categoryName);
      }
    } else {
      newCategories.remove(categoryName);
    }
    onCategoriesChanged(newCategories);
  }
}
