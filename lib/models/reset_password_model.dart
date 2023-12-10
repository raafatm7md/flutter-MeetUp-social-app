class ResetPassModel {
  bool? status;
  String? message;
  List<dynamic>? errors;

  ResetPassModel.fromJson(Map<String, dynamic> json){
    status = json['status'] ?? null;
    message = json['message'] ?? null;
    errors = json['errors'] ?? null;
  }
}
