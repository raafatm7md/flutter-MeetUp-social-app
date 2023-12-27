class UserModel {
  bool? status;
  String? message;
  List<dynamic>? errors;
  User? user;

  UserModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'] ?? json['msg'] ?? null;
    errors = json['errors'] ?? null;
    user = json['data'] != null ? User.fromJson(json['data']): null;
  }
}

class User {
  String? name;
  int? id;
  String? role;
  String? email;
  String? email_active;
  String? image;
  String? cover;
  String? birthday;
  String? token;
  double? latitude;
  double? longitude;

  User({
    required this.name,
    required this.id,
    required this.role,
    required this.email,
    required this.email_active,
    required this.image,
    required this.cover,
    required this.birthday,
    required this.token,
    required this.latitude,
    required this.longitude,
});

  User.fromJson(Map<String, dynamic> json){
    name = json['name'];
    id = json['id'];
    role = json['role'];
    email = json['email'];
    email_active = json['email_active'];
    image = json['image'];
    cover = json['cover'];
    birthday = json['birthday'];
    token = json['token'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'role': role,
      'email': email,
      'email_active': email_active,
      'image': image,
      'cover': cover,
      'birthday': birthday,
      'token': token,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}