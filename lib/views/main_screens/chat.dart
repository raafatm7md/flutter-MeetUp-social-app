import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        var users = SocialCubit.get(context).allUsers;
        var myId = SocialCubit.get(context).user?.id;
        return users != null
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildChatItem(context, users[index], myId!),
                separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 20.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[800],
                      ),
                    ),
                itemCount: users.length)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget buildChatItem(context, Data user, int myId) => InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(user.image ??
                    'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                user.name!,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailsScreen(
                  myId: myId,
                  user: user,
                ),
              ));
        },
      );
}
