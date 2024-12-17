import 'package:flutter/material.dart';
import 'package:qr_scanner/generate_qr.dart';
import 'package:qr_scanner/scan_qr.dart';
import 'package:qr_scanner/settings_page.dart';

class HomePage extends StatelessWidget {
  final Function(bool) onThemeChanged;

  const HomePage({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner & Generator'),
          backgroundColor: Colors.green,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(onThemeChanged: onThemeChanged),
                  ),
                );
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Scan Code'),
              Tab(text: 'Generate Code'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ScanQRCode(),
            GenerateQRCode(),
          ],
        ),
      ),
    );
  }
}
