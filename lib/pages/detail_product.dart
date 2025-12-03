import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/bloc/bloc.dart';
import 'package:qrcode/models/product.dart';
import 'package:qrcode/pages/add_product.dart';

class DetailProduct extends StatelessWidget {
  DetailProduct({super.key, required this.id, required this.data});

  final String id;
  final Product data;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  final TextEditingController priceC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = data.code;
    nameC.text = data.name;
    qtyC.text = data.qty.toString();
    priceC.text = data.price.toString();
    return Scaffold(
      appBar: AppBar(title: Text("Product ${data.name}")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                backgroundColor: Colors.white,
                data: data.productId,
                version: QrVersions.auto,
                size: 200,
              ),
            ],
          ),
          SizedBox(height: 25),
          TextField(
            autocorrect: false,
            controller: codeC,
            maxLength: 11,
            readOnly: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Product Code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Name Product",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Quantity Product",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: priceC,
            inputFormatters: [
              MoneyFormatter(),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Harga Product",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (codeC.text.length == 11) {
                final priceClean =
                    priceC.text.replaceAll('Rp ', '').replaceAll('.', '');
                // Bloc Product
                context.read<ProductBloc>().add(ProductEventEditProduct(
                      productId: data.productId,
                      name: nameC.text,
                      qty: int.tryParse(qtyC.text) ?? 0,
                      price: int.tryParse(priceClean) ?? 0,
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Code product must 10 character")));
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.blueAccent,
            ),
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is ProductStateCompleteUpdate) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Berhasil Update Data")));
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingUpdate
                      ? "Loading"
                      : "Update Product",
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(ProductEventDeleteProduct(productId: data.productId));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is ProductStateCompleteDelete) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Berhasil Menghapus Delete")));
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingDelete
                      ? "Loading"
                      : "Delete Product",
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
