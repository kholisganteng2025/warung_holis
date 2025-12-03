import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode/bloc/product/product_bloc.dart';

// class QrScannerPage extends StatefulWidget {
//   const QrScannerPage({super.key});

//   @override
//   State<QrScannerPage> createState() => _QrScannerPageState();
// }

// class _QrScannerPageState extends State<QrScannerPage> {
//   bool _isScanned = false;

//   final MobileScannerController controller = MobileScannerController(
//     facing: CameraFacing.back,
//     detectionSpeed: DetectionSpeed.normal,
//     detectionTimeoutMs: 500,
//     formats: [BarcodeFormat.qrCode],
//     returnImage: false,
//     torchEnabled: false,
//     autoZoom: true,
//     invertImage: false,
//   );

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'Scan Your Product',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blueAccent, // transparan
//         elevation: 0, // hilangkan bayangan

//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.flash_on,
//             ),
//             onPressed: () => controller.toggleTorch(),
//           ),
//         ],
//       ),
//       body: BlocConsumer<ProductBloc, ProductState>(
//         listener: (context, state) {
//           if (state is ProductStateError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//             // Reset scanning flag so user can try again
//             setState(() {
//               _isScanned = false;
//             });
//           } else if (state is ProductStateCompleteGenerateQrCode) {
//             // Successfully processed QR code
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('QR Code berhasil di scan!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Stack(
//             children: [
//               MobileScanner(
//                 controller: controller,
//                 onDetect: (capture) {
//                   if (_isScanned) return;

//                   final List<Barcode> barcodes = capture.barcodes;
//                   if (barcodes.isNotEmpty) {
//                     final String? qrCode = barcodes.first.rawValue;

//                     if (qrCode != null && qrCode.isNotEmpty) {
//                       debugPrint('QR Code detected: $qrCode');
//                       setState(() {
//                         _isScanned = true;
//                       });

//                       context.read<ProductBloc>().add(
//                             ProductEventScanQrCodeProduct(
//                               productId: qrCode,
//                               context: context,
//                             ),
//                           );
//                     }
//                   }
//                 },
//               ),
//               if (state is ProductStateLoadingGenerateQrCode)
//                 const Center(child: CircularProgressIndicator()),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blueAccent,
//         onPressed: () {
//           _isScanned
//               ? () {
//                   setState(() {
//                     _isScanned = false;
//                   });
//                 }
//               : null;
//         },
//         child: Icon(
//           Icons.replay_outlined,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

class QrScannerModal extends StatefulWidget {
  const QrScannerModal({super.key});

  @override
  State<QrScannerModal> createState() => _QrScannerModalState();
}

class _QrScannerModalState extends State<QrScannerModal> {
  final MobileScannerController controller = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 500,
    formats: [BarcodeFormat.qrCode],
    returnImage: false,
    torchEnabled: false,
    autoZoom: true,
    invertImage: false,
  );
  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (_, controllerScroll) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 120,
                child: Text(
                  "Check Your Qr Code",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (capture) {
                        if (_isScanned) return;

                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final String? qrCode = barcodes.first.rawValue;

                          if (qrCode != null && qrCode.isNotEmpty) {
                            debugPrint('QR Code detected: $qrCode');
                            setState(() {
                              _isScanned = true;
                            });

                            context.read<ProductBloc>().add(
                                  ProductEventScanQrCodeProduct(
                                    productId: qrCode,
                                    context: context,
                                  ),
                                );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
