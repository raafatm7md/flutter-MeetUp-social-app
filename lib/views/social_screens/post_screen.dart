import 'package:flutter/material.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/services/dio.dart';
import 'package:social_app/services/shared.dart';

class PostScreen extends StatefulWidget {
  final Posts post;
  final String myImg;
  final postUser;
  final int myID;
  const PostScreen(
      {super.key,
      required this.post,
      required this.postUser,
      required this.myImg,
      required this.myID});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(widget.postUser.image ??
                        'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postUser.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.post.createdAt!,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Colors.white),
                      )
                    ],
                  )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black,
                ),
              ),
              if (widget.post.postContent != null)
                Text(
                  widget.post.postContent!,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              if (widget.post.postImage != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage(widget.post.postImage!),
                        fit: BoxFit.cover,
                      )),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            Icon(
                              widget.post.totalLikes != 0 &&
                                      widget.post.reactedUserIds
                                          ?.contains(widget.myID)
                                  ? Icons.thumb_up_alt
                                  : Icons.thumb_up_alt_outlined,
                              size: 24.0,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${widget.post.totalLikes}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.chat_outlined,
                              size: 24.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${widget.post.totalComments} comment',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(widget.myImg),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'write a comment ...',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                                border: InputBorder.none),
                            onFieldSubmitted: (value) {
                              createComment(commentController.text.trim());
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        createComment(commentController.text.trim());
                      },
                      icon: Icon(
                        Icons.send_outlined,
                        color: Colors.amber,
                      ))
                ],
              ),
              widget.post.comments != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Comments:',
                          style: TextStyle(color: Colors.amber, fontSize: 20.0),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                buildCommentItem(widget.post.comments![index]),
                            separatorBuilder: (context, index) => Padding(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 20.0, vertical: 20.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                            itemCount: widget.post.comments!.length),
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommentItem(Comments comment) => Row(
        children: [
          CircleAvatar(
            radius: 22.0,
            backgroundImage: NetworkImage(comment.userImage ??
                'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.user!,
                  style: TextStyle(color: Colors.grey, fontSize: 16.0)),
              Text(
                comment.commment!,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ],
          ))
        ],
      );

  void createComment(String text) {
    if (text.isNotEmpty) {
      if (widget.post.comments == null) {
        widget.post.comments = [
          Comments(user: 'Me', commment: text, userImage: widget.myImg)
        ];
      } else {
        widget.post.comments?.add(
            Comments(user: 'Me', commment: text, userImage: widget.myImg));
      }
      widget.post.totalComments = (widget.post.totalComments! + 1);
      setState(() {});
      DioHelper.postData(
          url: 'user/posts/${widget.post.postId}/comment',
          data: {'content': text},
          token: CacheHelper.getData('token'));
      commentController.clear();
    }
  }
}
