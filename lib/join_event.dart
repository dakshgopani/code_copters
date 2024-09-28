import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'translation_service.dart';

class JoinEventScreen extends StatefulWidget {
  final String targetLang;

  JoinEventScreen({required this.targetLang});

  @override
  _JoinEventScreenState createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  final TextEditingController codeController = TextEditingController();
  String scannedCode = "";
  Map<String, String> _uiTranslations = {};
  bool _isLoading = true;
  final TranslationService _translationService = TranslationService();

  Future<void> _loadUiTranslations() async {
    try {
      final Map<String, String> translations = {
        'enterEventCode': await _translationService.translateText('Enter Event Code:', 'en', widget.targetLang),
        'joinEventButton': await _translationService.translateText('Join Event', 'en', widget.targetLang),
        'scanQRCode': await _translationService.translateText('Scan QR Code:', 'en', widget.targetLang),
      };

      setState(() {
        _uiTranslations = translations;
        _isLoading = false;
      });
    } catch (e) {
      print("Failed to load translations: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUiTranslations();
  }

  void joinEvent(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Joining Event'),
        content: Text('You are trying to join the event with code:\n$code'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void onDetect(BarcodeCapture barcodeCapture) {
    for (final barcode in barcodeCapture.barcodes) {
      setState(() {
        scannedCode = barcode.rawValue ?? "";
        joinEvent(scannedCode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Join Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_uiTranslations['enterEventCode'] ?? 'Enter Event Code:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            TextField(
              controller: codeController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => joinEvent(codeController.text),
              child: Text(_uiTranslations['joinEventButton'] ?? 'Join Event'),
            ),
            SizedBox(height: 10),
            Text(_uiTranslations['scanQRCode'] ?? 'Scan QR Code:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Expanded(
              child: MobileScanner(
                onDetect: onDetect,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
