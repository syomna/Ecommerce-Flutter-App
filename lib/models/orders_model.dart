class OrderModel {
  bool? status;
  Null message;
  Data? data;

  OrderModel({this.status, this.message, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  late List<OrderData> data;

  int? total;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new OrderData.fromJson(v));
      });
    }

    total = json['total'];
  }
}

class OrderData {
  int? id;
  dynamic total;
  String? date;
  String? status;

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    date = json['date'];
    status = json['status'];
  }
}
