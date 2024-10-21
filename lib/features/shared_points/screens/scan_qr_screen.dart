import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:puntos_client/features/shared_points/controller/user_points_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../common/models/response_model.dart';
import '../../../common/widgets/custom_app_bar.dart';

import '../../../helper/auth_helper.dart';
import '../../profile/controllers/profile_controller.dart';
import 'send_points_screen.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  final GlobalKey _qrKey = GlobalKey();
  QRViewController? _controller;

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn() && profileController.userInfoModel == null) {
      profileController.getUserInfo();
    }
  }

  //final PointsController pointsController = Get.find<PointsController>();

  // final PointsController pointsController =
  //     Get.put(PointsController(pointsService: Get.find()));

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    } else if (Platform.isIOS) {
      _controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Escanear QR Smart'),
      body: Stack(
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              'Apunta la cámara al código QR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      final scannedCode = scanData.code;

      _controller
          ?.pauseCamera(); // Pausar la cámara para evitar múltiples detecciones

      //part1 validar q no autoescane su codigo
      if (scannedCode == '${profileController.userInfoModel!.refCode}') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No puedes autoenviarte puntos'),
            backgroundColor: Colors.red,
          ),
        );
        _controller?.resumeCamera();
      } else {
        //part 2
        final UserPointsController controller =
            Get.find<UserPointsController>();
        ResponseModel responseModel =
            await controller.validateRefCode(scannedCode.toString());

        // Debug de la respuesta
        debugPrint("========== Código escaneado: $scannedCode");
        debugPrint(
            "========== Respuesta isSuccess: ${responseModel.isSuccess}");
        debugPrint("========== Respuesta mensaje: ${responseModel.message}");
        if (responseModel.isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SendPointsScreen(
                      scannedCode: scannedCode.toString(),
                      message: responseModel.message ?? 'Nombre User',
                    )),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(responseModel.message ?? 'Error al validar el código'),
              backgroundColor: Colors.red,
            ),
          );
          _controller?.resumeCamera();
        }
      }

      //end
      // if (scannedCode == "IQJF3DFFBJ") {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => SendPointsScreen()),
      //   );
      // } else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => ErrorScreen()),
      //   );
      // }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success')),
      body: Center(child: Text('QR Code Valid!')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(child: Text('Invalid QR Code!')),
    );
  }
}
