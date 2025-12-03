class Product {
  String code;
  String name;
  int qty;
  int price;
  String productId;

  Product({
    required this.code,
    required this.name,
    required this.qty,
    required this.price,
    required this.productId,
  });

  // MENERIMA DATA JSON BERBENTUK OBJECT
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        qty: json["qty"] ?? 0,
        price: json["price"] ?? 0,
        productId: json["productId"] ?? "",
      );

  // MENGIRIM DATA OBJECT KE JSON
  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "qty": qty,
        "price": price,
        "productId": productId,
      };
}
