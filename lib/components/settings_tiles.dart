import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;

  const SettingsSwitchTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }
}

class SettingsSliderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double value;
  final Function(double) onChanged;
  final bool enabled;

  const SettingsSliderTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: enabled ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: enabled ? Colors.black87 : Colors.grey,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: enabled ? Colors.grey[600] : Colors.grey,
            ),
          ),
          Slider(
            value: value,
            onChanged: enabled ? onChanged : null,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(value * 100).round()}%',
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class SettingsDropdownTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final List<String> options;
  final Function(String) onChanged;

  const SettingsDropdownTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: SizedBox.shrink(),
      ),
    );
  }
}
