import 'package:food/models/product_model/product_model.dart';

class OrderModel {
  List<ProductModel> product;
  double totalPrice;
  String payment;

  OrderModel({
    required this.product,
    required this.totalPrice,
    required this.payment,
  });
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> orderProduct = json["product"];
    return OrderModel(
      product: orderProduct.map((e) => ProductModel.fromJson(e)).toList(),
      totalPrice: json["totalPrice"],
      payment: json["payment"],
    );
  }

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "image": image,
  //   "name": name,
  //   "email": email,
  //   "phoneNumber": phoneNumber,
  // };
}
