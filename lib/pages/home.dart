import 'package:flutter/material.dart';
import 'package:qrcode/bloc/bloc.dart';
import 'package:qrcode/pages/qrcode.dart';
import 'package:qrcode/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Warung"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Stock Produk";
              icon = Icons.add_business;
              onTap = () => context.goNamed(Routes.addProduct);
              break;
            case 1:
              title = "List Produk";
              icon = Icons.list_rounded;
              onTap = () => context.goNamed(Routes.products);
              break;
            case 2:
              title = "Qr Code";
              icon = Icons.qr_code_scanner_outlined;
              onTap = () {
                // buka scanner modal dari bawah
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const QrScannerModal(),
                );
              };

              break;
            case 3:
              title = "Export PDF";
              icon = Icons.file_download_outlined;
              onTap = () => context
                  .read<ProductBloc>()
                  .add(ProductEventExportToPdfProduct());
              break;
            default:
          }

          return Material(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (index == 3)
                      ? BlocConsumer<ProductBloc, ProductState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is ProductStateLoadingExportToPdf) {
                              return CircularProgressIndicator(
                                color: Colors.white,
                              );
                            }
                            return SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(icon, size: 50));
                          },
                        )
                      : SizedBox(
                          height: 50, width: 50, child: Icon(icon, size: 50)),
                  SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());
          context.goNamed(Routes.login);
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
