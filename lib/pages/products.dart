import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/bloc/bloc.dart';
import 'package:qrcode/models/product.dart';
import 'package:qrcode/routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productB = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(title: Text("Product Page")),
      body: StreamBuilder<QuerySnapshot<Product>>(
        stream: productB.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Text("Tidak dapat mengambil data."),
            );
          }

          List<Product> allProducts = [];

          for (var element in snapshot.data!.docs) {
            allProducts.add(element.data());
          }

          if (allProducts.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black45,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: allProducts.length,
            itemBuilder: (context, index) {
              Product product = allProducts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.goNamed(
                      Routes.detailProduct,
                      pathParameters: {
                        "productId": product.productId,
                      },
                      extra: product,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 100,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(product.qty.toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            foregroundColor: Colors.white,
                            data: product.productId,
                            version: QrVersions.auto,
                            size: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
