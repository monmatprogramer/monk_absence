import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presence_app/conponent/cirecle_btn.dart';
import 'package:presence_app/db_config.dart';
import 'package:presence_app/body_container_scanner.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeScreen extends StatefulWidget {
  //session management
  String session;

  QrCodeScreen({super.key, required this.session});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String? qrImageUrl;
  bool _isSaving = false;
  bool _hasError = false;
  //method to fetch qr image
  Future<void> fetchQRCode() async {
    setState(() {
      _hasError = false;
      qrImageUrl = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${DbConfig.apiUrl}/api/qrcode/get-current-qrcode'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          qrImageUrl = data['qrImage'];
          widget.session = data['session'];
        });
      } else {
        final message = json.decode(response.body)['message'];
        //set error state
        setState(() {
          _hasError = true; //it has error state
        });
        _showSnackBar("$message", Colors.red);
      }
    } catch (e) {
      //set error state also
      setState(() {
        _hasError = true;
      });
      _showSnackBar('Could not connect to server: $e', Colors.red);
    }
  }

  //Save an image
  Future<void> _saveQRCode() async {
    if (qrImageUrl == null) {
      _showSnackBar('QR Code not loaded yet', Colors.red);
      setState(() {
        _isSaving = false;
      });
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      // Check if we have permission to access photos
      if (!await Gal.hasAccess() && mounted) {
        final hasAccess = await Gal.requestAccess();
        if (!hasAccess) {
          _showSnackBar('Gallery access permission denied', Colors.red);
          setState(() {
            _isSaving = false;
          });
          return;
        }
      }
      //If the app has access to the gallery
      final String base64String = qrImageUrl!.split(',').last;
      final Uint8List imageBytes = base64Decode(base64String);
      await Gal.putImageBytes(
        imageBytes,
        name:
            "QR_Code_${widget.session}_${DateTime.now().millisecondsSinceEpoch}",
      );
      _showSnackBar('QR Code saved to gallery successfully!', Colors.green);
    } catch (e) {
      _showSnackBar('Failed to save QR Code: $e', Colors.red);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<bool> showConfirmDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you want to save the QR Code?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  //Confirm before saving qr code image to gallery
  Future<void> onBackPressed() async {
    bool shouldSave = await showConfirmDialog(context);
    if (shouldSave) {
      //save data
      if (mounted) {
        _saveQRCode();
        //Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    fetchQRCode();
    super.initState();
  }

  void _showSnackBar(String message, Color backgroundColor) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> shareQRImage(BuildContext context) async {
    if (qrImageUrl == null) {
      _showSnackBar("QR Code not loaded yet!", Colors.red);
      return;
    }
    try {
      // Decode
      final String base64String = qrImageUrl!.split(',').last;
      final Uint8List imageBytes = base64Decode(base64String);

      // Write image to a temporary file
      final tempDir = await getTemporaryDirectory(); // Get cache directory
      final file = File(
        '${tempDir.path}/qr_code_${widget.session}_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);
      // Share the image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '➡️ Scan this QR Code to check in!',
        subject: 'QR Code Share',
      );
      debugPrint("➡️ File: ${file}");
    } catch (e) {
      debugPrint("❌ Error sharing file: $e");
      _showSnackBar('Failed to share QR Code: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('${widget.session.toUpperCase()} QR Code'),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 14),
        backgroundColor: Colors.blue,
        //action
        actions: [
          PopupMenuButton(
            icon: Image.asset(
              'images/qr_code.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            //set on select
            onSelected: (String onSelectValue) {
              switch (onSelectValue) {
                case 'Scan QR Code':
                  Navigator.pushNamed(context, '/sqc'); //sqc = scan qr code
                  break;
                case 'Scanner Screen':
                  Navigator.pushNamed(context, '/scs'); //scs = scanner screen
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: "Scan QR Code",
                child: Text("Scan QR"),
              ),
              // const PopupMenuItem(
              //   value: "Scanner Screen",
              //   child: Text("Scanner Screen"),
              // ),
            ],
          ),
        ],
      ),
      // body: Center(
      //   child: qrImageUrl != null
      //       ? Image.memory(base64Decode(qrImageUrl!.split(',').last))
      //       : CircularProgressIndicator(),
      body: Center(
        child: qrImageUrl != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BodyContainerScanner(
                    date:
                        "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString()}",
                    title: widget.session,
                    qrImageUrl: Image.memory(
                      base64Decode(qrImageUrl!.split(',').last),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CirecleBtn(
                        icon: "images/downloads.png",
                        label: "Download",
                        color: Colors.green,
                        onTap: onBackPressed,
                      ),
                      const SizedBox(height: 30),
                      CirecleBtn(
                        icon: "images/share.png",
                        label: "Share",
                        color: Colors.redAccent,
                        onTap: () {
                          shareQRImage(context);
                        },
                      ),
                    ],
                  ),
                ],
              )
            : _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: Colors.yellow,
                  ),
                  const SizedBox(height: 20),
                  // const Text(
                  //   'Failed to load QR code',
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.asset("images/stopwatch.png"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: fetchQRCode,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
