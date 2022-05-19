import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  late QRViewController controller;
  late String result;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor,width: 8.0)),
          height: 200.0,
          width: 200.0,
          child: buildQRView(context),
        ),
      ),
    );
  }


  Widget buildQRView(BuildContext context) {
    return QRView(key: qrKey, onQRViewCreated: onQRViewCreated,formatsAllowed: [],);
  }

  void onQRViewCreated(QRViewController controller){
    setState(() {
      this.controller=controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          result = scanData.code;
          http.post(Uri.parse("https://inducedapi.vercel.app/cc?idp="+result)).then((value) => print(value.request.toString()));
        });
      });
    });
  }
}