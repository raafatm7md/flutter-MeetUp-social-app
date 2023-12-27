import 'package:flutter/material.dart';
import 'package:social_app/models/all_users_model.dart';
import 'package:social_app/views/social_screens/post_screen.dart';

import '../../models/post_model.dart';
import '../../services/dio.dart';
import '../../services/shared.dart';
import 'chat_details.dart';

class UserProfile extends StatefulWidget {
  final int myID;
  final Data user;
  final String myImg;
  UserProfile(
      {super.key, required this.myID, required this.user, required this.myImg});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<Posts>? userPosts = [];

  @override
  initState() {
    super.initState();
    getUserPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.user.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 190.0,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0)),
                          image: DecorationImage(
                            image: NetworkImage(widget.user.cover != null
                                ? '${widget.user.cover}'
                                : 'https://e0.pxfuel.com/wallpapers/135/566/desktop-wallpaper-purple-for-purple-damask-peach-flock-by-for-your-mobile-tablet-explore-purple-damask-black-and-purple-purple-thumbnail.jpg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  CircleAvatar(
                    radius: 65.0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(widget.user.image != null
                          ? '${widget.user.image}'
                          : 'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailsScreen(
                              myId: widget.myID,
                              user: widget.user,
                            ),
                          ));
                    },
                    child: Text('Chat'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
                child: userPosts?.length == 0
                    ? Center(
                        child: Text(
                          '${widget.user.name} doesn\'t have posts yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildPostItem(context, userPosts![index]),
                        itemCount: userPosts!.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8.0,
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  Widget buildPostItem(context, Posts post) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        color: Colors.purpleAccent.withOpacity(0.022),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times'),
                      ),
                      Text(
                        post.createdAt!,
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
              if (post.postContent != null)
                Text(
                  post.postContent!,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              if (post.postImage != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage(post.postImage!),
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
                              post.totalLikes != 0 &&
                                      post.reactedUserIds?.contains(widget.myID)
                                  ? Icons.thumb_up_alt
                                  : Icons.thumb_up_alt_outlined,
                              size: 24.0,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${post.totalLikes}',
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
                              '${post.totalComments} comment',
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
                    child: InkWell(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(widget.myImg),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'write a comment ...',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostScreen(
                                post: post,
                                myImg: widget.myImg,
                                postUser: widget.user,
                                myID: widget.myID,
                              ),
                            ));
                      },
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 24.0,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Like',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        )
                      ],
                    ),
                    onTap: () {
                      likePost(post.postId!);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      );

  void getUserPost() {
    DioHelper.getData(
            url: 'user/${widget.user.id}/posts',
            token: CacheHelper.getData('token'))
        .then((value) {
      PostsModel postsResponse = PostsModel.fromJson(value.data);
      if (postsResponse.status == true) {
        setState(() {
          userPosts = postsResponse.data?.posts?.reversed.toList();
        });
      }
    });
  }

  void likePost(int postId) {
    DioHelper.postData(
        url: 'user/posts/$postId/react',
        data: {},
        token: CacheHelper.getData('token'));
  }
}
