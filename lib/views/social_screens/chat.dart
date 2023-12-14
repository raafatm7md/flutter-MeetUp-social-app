import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/views/app/social_cubit.dart';
import 'package:social_app/views/social_screens/chat_details.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        // var users;
        return true
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildChatItem(context),
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
                itemCount: 10)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget buildChatItem(context) => InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage('user.image!'),
              ),
              const SizedBox(
                width: 15,
              ),
              Text('user.name!', style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
        // onTap: () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ChatDetailsScreen(user: user),
        //       ));
        // },
      );
}
