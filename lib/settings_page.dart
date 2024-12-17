import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsPage({super.key, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Load QR code history from shared preferences
  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('qr_history') ??
          []; // Retrieve history or initialize to empty list
    });
  }

  // Clear the QR code history from shared preferences
  Future<void> _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('qr_history'); // Remove the history entry
    setState(() {
      history.clear(); // Clear the local history list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Switch for toggling dark mode
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: Theme.of(context).brightness ==
                Brightness.dark, // Check if the current theme is dark mode
            onChanged: (value) {
              widget.onThemeChanged(
                  value); // Call the callback to change the theme
            },
          ),
          const SizedBox(height: 20),
          // List tile to show QR code history
          ListTile(
            title: const Text('QR Code History'),
            trailing: const Icon(Icons.history),
            onTap: () {
              _showHistoryDialog();
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _clearHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Clear History',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Display QR code history in a dialog
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('QR Code History'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: history.isNotEmpty
                ? ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(history[index]),
                        leading: const Icon(Icons.qr_code),
                      );
                    },
                  )
                : const Center(
                    child: Text('No history available'),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
