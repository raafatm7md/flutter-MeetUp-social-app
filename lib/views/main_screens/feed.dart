import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/views/social_screens/new_post.dart';
import '../cubits/app/social_cubit.dart';
import '../social_screens/post_screen.dart';
import '../social_screens/user_profile.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        RefreshController _refreshController =
            RefreshController(initialRefresh: false);
        var posts = cubit.allPosts;

        Widget buildPostItem(context, Posts post) {
          var postUser;
          var postlikers = [];
          if (post.userId == SocialCubit.get(context).user?.id) {
            postUser = SocialCubit.get(context).user;
          } else {
            postUser = SocialCubit.get(context)
                .allUsers
                ?.singleWhere((element) => element.id == post.userId);
          }
          if (post.totalLikes != 0 && post.reactedUserIds != 0) {
            post.reactedUserIds.forEach((id) {
              if (id == SocialCubit.get(context).user?.id) {
                postlikers.add(SocialCubit.get(context).user);
              } else {
                postlikers.add(SocialCubit.get(context)
                    .allUsers
                    ?.singleWhere((element) => element.id == id));
              }
            });
          }
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5.0,
            color: Colors.purpleAccent.withOpacity(0.022),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              myID: cubit.user!.id!,
                              user: postUser,
                              myImg: cubit.user?.image ??
                                  'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg',
                            ),
                          ));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(postUser!.image ??
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
                              postUser.name!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
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
                            child: post.totalLikes != 0 &&
                                    post.reactedUserIds != 0
                                ? PopupMenuButton(
                                    itemBuilder: (BuildContext context) {
                                      return postlikers.map((e) {
                                        return PopupMenuItem(
                                            child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(e!
                                                      .image ??
                                                  'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              e.name,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ));
                                      }).toList();
                                    },
                                    color: Colors.black,
                                    child: Row(
                                      children: [
                                        Icon(
                                          post.totalLikes != 0 &&
                                                  post.reactedUserIds?.contains(
                                                      SocialCubit.get(context)
                                                          .user
                                                          ?.id)
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
                                              color: Colors.white,
                                              fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Icon(
                                        post.totalLikes != 0 &&
                                                post.reactedUserIds?.contains(
                                                    SocialCubit.get(context)
                                                        .user
                                                        ?.id)
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
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PostScreen(
                                          post: post,
                                          postUser: postUser,
                                          myImg: cubit.user?.image ??
                                              'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg',
                                          myID: cubit.user!.id!),
                                    ));
                              },
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
                                    '${post.totalComments} comments',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  )
                                ],
                              ),
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
                                backgroundImage: NetworkImage(cubit
                                        .user?.image ??
                                    'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                'write a comment ...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostScreen(
                                      post: post,
                                      postUser: postUser,
                                      myImg: cubit.user?.image ??
                                          'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg',
                                      myID: cubit.user!.id!),
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            )
                          ],
                        ),
                        onTap: () {
                          cubit.likePost(post.postId!);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }

        return posts!.length > 0
            ? Scaffold(
                body: SmartRefresher(
                  enablePullDown: true,
                  header: MaterialClassicHeader(),
                  controller: _refreshController,
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 1000));
                    cubit.getAllPosts();
                    _refreshController.refreshCompleted();
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildPostItem(context, posts[index]),
                          itemCount: posts.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8.0,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        )
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewPostScreen(user: cubit.user!),
                        ));
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: CircleBorder(),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
