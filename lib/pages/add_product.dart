import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/bloc/bloc.dart';
import 'package:qrcode/routes/router.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  final TextEditingController priceC = TextEditingController();

  String generateProductCode() {
    final rand = DateTime.now().millisecondsSinceEpoch.toString().substring(5);
    return "PRD$rand";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock Product")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: codeC,
                  maxLength: 11, // PRD + 10 angka
                  decoration: InputDecoration(
                    labelText: "Product Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  codeC.text = generateProductCode();
                },
              ),
            ],
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
            controller: priceC,
            keyboardType: TextInputType.number,
            inputFormatters: [
              MoneyFormatter(),
            ],
            decoration: InputDecoration(
              labelText: "Price Product",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (codeC.text.length == 11) {
                final priceClean =
                    priceC.text.replaceAll('Rp ', '').replaceAll('.', '');

                // Bloc Product
                context.read<ProductBloc>().add(ProductEventAddProduct(
                      code: codeC.text,
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

                if (state is ProductStateCompleteAdd) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Berhasil Menambahkan Product")));
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingAdd
                      ? "Loading..."
                      : "Add Product",
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class MoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll('Rp ', '').replaceAll('.', '');

    String newText = text.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    );

    newText = "Rp $newText";

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
