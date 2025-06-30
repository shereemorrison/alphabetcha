import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool enabled;
  final Color? textColor;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.enabled = true,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled
            ? (textColor ?? Theme.of(context).colorScheme.primary)
            : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? (textColor ?? Colors.black87) : Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: enabled
          ? () {
              Navigator.pop(context);
              onTap();
            }
          : null,
      enabled: enabled,
    );
  }
}
