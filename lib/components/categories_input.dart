import 'package:flutter/material.dart';

class CategoriesInput extends StatelessWidget {
  final List<String> categories;
  final Map<String, TextEditingController> controllers;
  final bool isSubmitted;
  final Function(String, String) onAnswerChanged;

  const CategoriesInput({
    Key? key,
    required this.categories,
    required this.controllers,
    required this.isSubmitted,
    required this.onAnswerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final controller = controllers[category]!;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                enabled: !isSubmitted,
                decoration: InputDecoration(
                  hintText: 'Enter a $category...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                onChanged: (value) => onAnswerChanged(category, value),
              ),
            ],
          ),
        );
      },
    );
  }
}
