class AddOrderModel {
  bool? status;
  String? message;

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
