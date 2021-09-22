class FavoriteModel {
  bool status;
  Null message;
  Data data;

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

}

class Data {
  List<FavoriteData> data;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new FavoriteData.fromJson(v));
      });
    }
  }

}

class FavoriteData {
  int id;
  FavoriteProduct product;

  FavoriteData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? new FavoriteProduct.fromJson(json['product']) : null;
  }
}

class FavoriteProduct {
  int id;
  int price;
  int oldPrice;
  int discount;
  String image;
  String name;
  String description;

  FavoriteProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

}