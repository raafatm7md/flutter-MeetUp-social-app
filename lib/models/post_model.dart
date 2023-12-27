class PostsModel {
  bool? status;
  DataResponse? data;

  PostsModel({this.status, this.data});

  PostsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new DataResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataResponse {
  List<Posts>? posts;

  DataResponse({this.posts});

  DataResponse.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  int? userId;
  int? postId;
  String? postContent;
  String? postImage;
  String? createdAt;
  int? totalLikes;
  dynamic reactedUserIds;
  int? totalComments;
  List<Comments>? comments;

  Posts(
      {this.userId,
        this.postId,
        this.postContent,
        this.postImage,
        this.createdAt,
        this.totalLikes,
        this.reactedUserIds,
        this.totalComments,
        this.comments});

  Posts.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    postId = json['post_id'];
    postContent = json['post_content'];
    postImage = json['post_image'];
    createdAt = json['created_at'];
    totalLikes = json['total_likes'];
    reactedUserIds = json['reacted_user_ids'];
    totalComments = json['total_comments'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['post_content'] = this.postContent;
    data['post_image'] = this.postImage;
    data['created_at'] = this.createdAt;
    data['total_likes'] = this.totalLikes;
    data['reacted_user_ids'] = this.reactedUserIds;
    data['total_comments'] = this.totalComments;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? commment;
  String? user;
  String? userImage;

  Comments({this.commment, this.user, this.userImage});

  Comments.fromJson(Map<String, dynamic> json) {
    commment = json['commment'];
    user = json['user'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commment'] = this.commment;
    data['user'] = this.user;
    data['user_image'] = this.userImage;
    return data;
  }
}
