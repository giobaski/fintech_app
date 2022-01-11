import 'dart:convert';

import 'package:intl/intl.dart';

class Installment {
  int? id;
  int? storeId;
  int? userId;
  String? userName;
  String? userPhone;
  String? userPn;
  String? storeTitle;
  List<Product>? products = [];
  // String? marketPrice;
  // String? participation;
  String? installmentStatus;
  DateTime? date;

  Installment({
    this.id,
    this.storeId,
    this.userId,
    this.userName,
    this.userPhone,
    this.userPn,
    this.storeTitle,
    this.products,
    // this.marketPrice,
    // this.participation,
    this.installmentStatus,
    this.date,
  });

  double get productsTotalPrice {
    return products!.fold(0, (sum, product) => sum + product.total);
  }


  factory Installment.fromJson(Map<String, dynamic> json) => Installment(
    id: json["id"],
    storeId: json["store_id"],
    userId: json["user_id"],
    userName: json["user_name"],
    userPhone: json["user_phone"],
    userPn: json["user_pn"],
    storeTitle: json["store_title"],
    products: (json["products"] != null)
        ? (jsonDecode((json["products"] as String).replaceAll("\\", "")) as List)
                            .map((product) => Product.fromJson(product)).toList()
        : [],
    // marketPrice: json["market_price"]?? "",
    // participation: json["participation"]?? '',
    installmentStatus: json["installment_status"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_id": storeId,
    "user_id": userId,
    "user_name": userName,
    "user_phone": userPhone,
    "user_pn": userPn,
    "store_title": storeTitle,
    // "products": products,
    // "market_price": marketPrice,
    // "participation": participation,
    "installment_status": installmentStatus,
    "date": date!.toIso8601String(),
  };

  @override
  String toString() {
    return 'Installment{id: $id, storeId: $storeId, userId: $userId, userName: $userName, userPhone: $userPhone, userPn: $userPn, storeTitle: $storeTitle, products: $products, installmentStatus: $installmentStatus, date: $date}';
  }
  
}





class Product {
  var name;
  var amount;
  var price;
  var total;

  Product({
    this.name,
    this.amount,
    this.price,
    this.total
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json["დასახელება"],
      amount: json["რაოდ"],
      price: json["ერთ_ფასი"],
      total: json["ჯამი"],
  );

  @override
  String toString() {
    return 'Product{name: $name, amount: $amount, price: $price, total: $total}';
  }
}


