part of 'product_bloc.dart';

sealed class ProductState {}

//  state / kondisi product saat ini
// 1. Product Awal -> masih kosong
// 2. Product loading...
// 3. Product Complete -> ketika sudah berhasil mendapatkan data dari database

final class ProductStateInitial extends ProductState {}

final class ProductStateLoadingAdd extends ProductState {}

final class ProductStateLoadingExportToPdf extends ProductState {}

final class ProductStateLoadingUpdate extends ProductState {}

final class ProductStateLoadingDelete extends ProductState {}

final class ProductStateLoadingGenerateQrCode extends ProductState {}

final class ProductStateCompleteAdd extends ProductState {}

final class ProductStateCompleteUpdate extends ProductState {}

final class ProductStateCompleteDelete extends ProductState {}

final class ProductStateCompleteExportToPdf extends ProductState {}

final class ProductStateCompleteGenerateQrCode extends ProductState {}

final class ProductStateError extends ProductState {
  ProductStateError(this.message);
  final String message;
}
