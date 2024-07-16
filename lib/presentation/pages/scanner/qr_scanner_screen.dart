import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/presentation/controllers/qr_scanner_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class QRScannerScreen extends StatelessWidget {
  final QRScannerController controller = Get.put(QRScannerController());
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return Scaffold(
     appBar: AppBar(
        title: const Text(
          'ScanQR',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Obx(
                    () => controller.showScanner.value
                        ? QRView(
                            key: controller.qrKey,
                            onQRViewCreated: controller.onQRViewCreated,
                            overlay: QrScannerOverlayShape(
                              borderColor: AppColors.accentColor,
                              borderRadius: 10,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: scanArea,
                            ),
                            onPermissionSet: (ctrl, p) =>
                                controller.onPermissionSet(context, ctrl, p),
                          )
                        : Container(),
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
