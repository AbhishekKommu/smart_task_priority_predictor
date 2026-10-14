import 'package:flutter/material.dart';
import '../app.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    final app = SmartTaskApp.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: app.isDark,
            onChanged: (v) {
              app.setDark(v);
              _storage.saveDark(v);
              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear all tasks'),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear all tasks?'),
                  content: const Text('This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              if (ok == true) await _storage.clearAll();
            },
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Smart Task Priority Predictor'),
            subtitle: Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }
}
