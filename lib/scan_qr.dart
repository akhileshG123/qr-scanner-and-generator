import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String qrResult = "\"Scanned data will appear here\"";

  // List of potentially harmful keywords or domains
  final List<String> harmfulSites = [
    "phishing.com",
    "malware.com",
    "dangerous-site.com",
  ];

  // Function to start the QR code scanning process
  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        qrResult = qrCode.toString();
      });

      // Validate if the QR code is a harmful URL
      if (_isPotentiallyHarmful(qrResult)) {
        _showHarmfulUrlAlert();
      } else {
        _openScannedURL(qrResult);
      }
    } on PlatformException {
      qrResult = 'Failed to read QR Code';
    } catch (error) {
      qrResult = 'Failed to read QR Code';
    }
  }

  // Check if the URL is harmful
  bool _isPotentiallyHarmful(String url) {
    for (String harmfulSite in harmfulSites) {
      if (url.contains(harmfulSite)) {
        return true;
      }
    }
    return false;
  }

  // Show an alert dialog if the URL is potentially harmful
  void _showHarmfulUrlAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning!'),
        content: const Text(
            'This URL may lead to a harmful or unsafe website. Proceed with caution.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openScannedURL(qrResult);
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  // Open the scanned URL using a URL launcher
  Future<void> _openScannedURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(height: 200, 'assets/images/scanner.png'),
            const SizedBox(height: 30),
            Text(
              qrResult == '-1' ? "\"Scanned data will appear here\"" : qrResult,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                scanQR();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Scan QR Code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
