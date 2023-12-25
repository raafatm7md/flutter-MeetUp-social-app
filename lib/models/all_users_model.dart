class AllUsers {
  bool? status;
  String? message;
  List<Data>? data;

  AllUsers({this.status, this.message, this.data});

  AllUsers.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? null;
    message = json['message'] ?? json['msg'] ?? null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? token;
  int? id;
  String? name;
  String? email;
  String? emailActive;
  String? role;
  String? image;
  String? cover;
  String? birthday;
  double? longitude;
  double? latitude;

  Data(
      {this.token,
        this.id,
        this.name,
        this.email,
        this.emailActive,
        this.role,
        this.image,
        this.cover,
        this.birthday,
        this.longitude,
        this.latitude});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailActive = json['email_active'];
    role = json['role'];
    image = json['image'];
    cover = json['cover'];
    birthday = json['birthday'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }
}
