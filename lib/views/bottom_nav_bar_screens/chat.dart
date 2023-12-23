import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app/models/all_users_model.dart';
import 'package:social_app/views/cubits/app/social_cubit.dart';
import '../social_screens/chat_details.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        RefreshController _refreshController =
            RefreshController(initialRefresh: false);
        var users = SocialCubit.get(context).allUsers;
        return users != null
            ? SmartRefresher(
                enablePullDown: true,
                header: MaterialClassicHeader(),
                controller: _refreshController,
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 1000));
                  _refreshController.refreshCompleted();
                },
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildChatItem(context, users[index]),
                    separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 20.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                        ),
                    itemCount: users.length),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget buildChatItem(context, Data user) => InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                // backgroundImage: NetworkImage(user.image!),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                user.name!,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailsScreen(),
              ));
        },
      );
}
