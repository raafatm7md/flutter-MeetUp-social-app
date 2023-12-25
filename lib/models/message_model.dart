class AllMessages {
  List<Message>? allMessages;

  AllMessages({this.allMessages});

  AllMessages.fromJson(json) {
      allMessages = <Message>[];
      json.forEach((v) {
        allMessages!.add(new Message.fromJson(v));
      });
  }
}

class Message {
  String? auther;
  String? id;
  String? message;
  String? createdAt;

  Message({
    required this.auther,
    required this.id,
    required this.message,
    required this.createdAt,
  });

  Message.fromJson(Map<String, dynamic> json){
    auther = json['auther'];
    id = json['id'];
    message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'auther': auther,
      'id': id,
      'message': message,
      'createdAt': createdAt,
    };
  }
}