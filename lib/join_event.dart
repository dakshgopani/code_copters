import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class JoinEventScreen extends StatefulWidget {
  @override
  _JoinEventScreenState createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  final TextEditingController codeController = TextEditingController();
  String scannedCode = "";
  bool isDialogOpen = false;

  void joinEvent(String code) {
    isDialogOpen = true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Joining Event',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You are trying to join the event with code:\n$code',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isDialogOpen = false; // Allow scanning after popup is closed
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDetect(BarcodeCapture barcodeCapture) {
    if (!isDialogOpen) { // Only allow scanning if dialog is not open
      for (final barcode in barcodeCapture.barcodes) {
        setState(() {
          scannedCode = barcode.rawValue ?? "";
          joinEvent(scannedCode);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Join Event',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0, // Flat header
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the code or scan QR code:',
              style: TextStyle(
                fontSize: 22,
                color: Colors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            // Input for event code
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: codeController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.event, color: Colors.orange),
                  labelText: 'Event Code',
                  labelStyle: TextStyle(color: Colors.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Button to join event by entering the code
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => joinEvent(codeController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.orange.withOpacity(0.3),
                ),
                child: Text(
                  'Join Event',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Scan QR Code:',
              style: TextStyle(
                fontSize: 22,
                color: Colors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              // QR code scanner with rounded corners
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      onDetect: onDetect,
                      fit: BoxFit.cover,
                    ),
                    // Black overlay to enhance focus on the scanner
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        height: 40,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        height: 40,
                      ),
                    ),
                    // Rounded scanning frame with orange border
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      child: Text(
                        'Align QR code within the frame',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
