class ProductsByCategoryModel {
  bool? status;
  Data? data;

  ProductsByCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

}

class Data {

  late List<ProductByCategoryData> data;


  Data.fromJson(Map<String, dynamic> json) {
 
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new ProductByCategoryData.fromJson(v));
      });
    }
  }

 
}

class ProductByCategoryData {
  int? id;
  dynamic price;
  dynamic oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;
 // List<String> images;
  bool? inFavorites;
  bool? inCart;


  ProductByCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  //  images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

 
}