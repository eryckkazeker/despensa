
import 'package:despensa/controller/scanner_screen_controller.dart';
import 'package:despensa/models/scan_mode.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class Scanner extends StatefulWidget {
  final ScanMode scanMode;
  final ScannerScreenController scannerScreenController;

  Scanner(this.scanMode, this.scannerScreenController);

  @override
  ScannerState createState() => ScannerState(scanMode, scannerScreenController);
}

class ScannerState extends State<Scanner> {

  ScanMode scanMode;

  final ScannerScreenController scannerController;
  final MobileScannerController controller = MobileScannerController();

  bool _isScanned = false;

  ScannerState(this.scanMode, this.scannerController);

  @override
  void initState() {
    super.initState();
    controller.start();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leia o código de barras'),
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              MobileScanner(
                controller: controller,
                errorBuilder: (
                  BuildContext context,
                  MobileScannerException error,
                  Widget? child,
                ) {
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.contain,
                onDetect: (BarcodeCapture barcode) {
                  if (!_isScanned) {
                    barcodeScan(barcode.barcodes.first.displayValue!);
                    _isScanned = true;
                  }
                  
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  void barcodeScan(String barcode) {
    scannerController.scanBarcode(barcode, this.scanMode, context);
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}