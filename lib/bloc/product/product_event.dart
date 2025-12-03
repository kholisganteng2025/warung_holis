part of 'product_bloc.dart';

sealed class ProductEvent {}

// Aksi ==> tindakan
// 1. add product
// 2. edit product
// 4. delete product

class ProductEventAddProduct extends ProductEvent {
  ProductEventAddProduct({
    required this.code,
    required this.name,
    required this.qty,
    required this.price,
  });

  // final Product product;

  final String code;
  final String name;
  final int qty;
  final int price;
}

class ProductEventEditProduct extends ProductEvent {
  ProductEventEditProduct(
      {required this.productId,
      required this.name,
      required this.qty,
      required this.price});

  final String productId;
  final String name;
  final int qty;
  final int price;
}

class ProductEventDeleteProduct extends ProductEvent {
  ProductEventDeleteProduct({required this.productId});

  final String productId;
}

class ProductEventExportToPdfProduct extends ProductEvent {}

class ProductEventScanQrCodeProduct extends ProductEvent {
  ProductEventScanQrCodeProduct(
      {required this.productId, required this.context});
  final String productId;
  final BuildContext context;
}
