class ProductModel {
  String id;
  String image;
  String name;
  String discription;
  String price;
  String status;
  bool isFavourite;
  int? quantity;
  ProductModel({
    required this.id,
    required this.image,
    required this.name,
    required this.discription,
    required this.price,
    required this.status,
    required this.isFavourite,
    this.quantity,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        discription: json["discription"],
        price: json["price"],
        status: json["status"],
        isFavourite: false,
        quantity: json["quantity"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "discription": discription,
        "price": price,
        "status": status,
        "isFavourite": isFavourite,
        "quantity": quantity,
      };

  ProductModel copyWith({
    int? quantity,
  }) =>
      ProductModel(
          id: id,
          image: image,
          name: name,
          discription: discription,
          price: price,
          status: status,
          isFavourite: isFavourite,
          quantity: quantity,
      );
}
