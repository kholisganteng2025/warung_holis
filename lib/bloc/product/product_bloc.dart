import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qrcode/models/product.dart';
import 'package:qrcode/routes/router.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Product>> streamProducts() async* {
    yield* firestore
        .collection("products")
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    // Add Product
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingAdd());
        // Add Product Here
        var result = await firestore.collection("products").add({
          "name": event.name,
          "code": event.code,
          "qty": event.qty,
          "price": event.price,
        });

        await firestore
            .collection("products")
            .doc(result.id)
            .update({"productId": result.id});

        emit(ProductStateCompleteAdd());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    // Edit Product
    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingUpdate());
        // Edit Product Here
        await firestore.collection("products").doc(event.productId).update({
          "name": event.name,
          "qty": event.qty,
          "price": event.price,
        });

        emit(ProductStateCompleteUpdate());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    // Delete Product
    on<ProductEventDeleteProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingDelete());
        await firestore.collection("products").doc(event.productId).delete();
        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    on<ProductEventExportToPdfProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingExportToPdf());

        // 1. ambil semuah data product dari firebase
        var querrysnap = await firestore
            .collection("products")
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson(),
            )
            .get();

        List<Product> allProduct = [];

        for (var element in querrysnap.docs) {
          Product product = element.data();
          allProduct.add(product);
        }
        // allproduct -> udah ada isinya, tergantung DATABASENYA.

        // 2. Bikin Pdfnya (Create Pdf) -> taro dimana? -> local storage -> butuh path location
        final pdf = pw.Document();

        // TODO: masukin data products ke pdf
        var data = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
        var myFont = pw.Font.ttf(data);

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              // Mau build apa?
              return [
                pw.Column(
                  children: [
                    // Judul Title
                    pw.Center(
                        child: pw.Text("Catalog Products",
                            style: pw.TextStyle(font: myFont, fontSize: 24))),
                    pw.SizedBox(height: 20),
                    // Tabelnya
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColor.fromHex("#000000"),
                        width: 2,
                      ),
                      children: [
                        pw.TableRow(
                          children: [
                            // TODO:: ini untuk nomor barang
                            pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Text(
                                "No",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            // TODO:: ini untuk kode barang
                            pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Text(
                                "Product Code",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            // TODO:: ini untuk nama barang
                            pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Text(
                                "Product Name",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            // TODO:: ini untuk quantity barang
                            pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Text(
                                "Quantity",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            // TODO:: ini untuk Qr Code
                            pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Text(
                                "QR code",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...allProduct.asMap().entries.map(
                          (e) {
                            final index = e.key + 1;
                            final product = e.value;

                            return pw.TableRow(children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  "${index}",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 10),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  "${product.code}",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 10),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  "${product.name}",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 10),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  "${product.qty}",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 10),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.BarcodeWidget(
                                  barcode: pw.Barcode.qrCode(),
                                  data: product.code,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ]);
                          },
                        )
                      ],
                    ),
                  ],
                )
              ];
            },
          ),
        );

        // 3. Open Pdfnya
        Uint8List bytes = await pdf.save();

        final dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/myproducts.pdf");

        // Memasukan data bytesnya ke file pdf
        await file.writeAsBytes(bytes);

        await OpenFile.open(file.path);

        print("Disini " + file.path);

        emit(ProductStateCompleteExportToPdf());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    on<ProductEventScanQrCodeProduct>(
      (event, emit) async {
        try {
          // Ambil productId dari QR yang discan
          final productId = event.productId;

          // Query Firestore berdasarkan productId
          final querySnapshot = await firestore
              .collection("products")
              .where('productId', isEqualTo: productId)
              .withConverter<Product>(
                fromFirestore: (snapshot, _) =>
                    Product.fromJson(snapshot.data()!),
                toFirestore: (product, _) => product.toJson(),
              )
              .get();

          // Cek apakah ada data
          if (querySnapshot.docs.isEmpty) {
            debugPrint('No product found with productId: $productId');
            emit(ProductStateError("Produk tidak ditemukan."));
            return;
          }

          // Ambil product dan document id
          final product = querySnapshot.docs.first.data();
          final productDocId = querySnapshot.docs.first.id;

          // Navigasi ke detail product
          event.context.goNamed(
            Routes.detailProduct,
            pathParameters: {'productId': productDocId},
            extra: product,
          );

          emit(ProductStateCompleteAdd());
        } catch (e) {
          emit(ProductStateError(e.toString()));
        }
      },
    );
  }
}
