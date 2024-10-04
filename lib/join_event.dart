import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class JoinEventScreen extends StatefulWidget {
  @override
  _JoinEventScreenState createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  final TextEditingController codeController = TextEditingController();
  String scannedCode = "";

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
    return Scaffold(
      appBar: AppBar(title: const Text('Join Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Event Code:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            TextField(
              controller: codeController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => joinEvent(codeController.text),
              child: Text('Join Event'),
            ),
            SizedBox(height: 10),
            Text('Scan QR Code:', style: TextStyle(fontSize: 20)),
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
