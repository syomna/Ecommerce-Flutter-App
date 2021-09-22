class OrderDetailsModel {
  bool status;
  Null message;
  Data data;

  OrderDetailsModel({this.status, this.message, this.data});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  int id;
  dynamic cost;
  int discount;
  dynamic points;
  dynamic vat;
  dynamic total;
  dynamic pointsCommission;
  String promoCode;
  String paymentMethod;
  String date;
  String status;
  OrderAddress address;
  List<OrderProducts> products;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'];
    discount = json['discount'];
    points = json['points'];
    vat = json['vat'];
    total = json['total'];
    pointsCommission = json['points_commission'];
    promoCode = json['promo_code'];
    paymentMethod = json['payment_method'];
    date = json['date'];
    status = json['status'];
    address = json['address'] != null
        ? new OrderAddress.fromJson(json['address'])
        : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products.add(new OrderProducts.fromJson(v));
      });
    }
  }
}

class OrderAddress {
  int id;
  String name;
  String city;
  String region;
  String details;
  String notes;
  dynamic latitude;
  dynamic longitude;

  OrderAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    region = json['region'];
    details = json['details'];
    notes = json['notes'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class OrderProducts {
  int id;
  int quantity;
  dynamic price;
  String name;
  String image;

  OrderProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    name = json['name'];
    image = json['image'];
  }
}
