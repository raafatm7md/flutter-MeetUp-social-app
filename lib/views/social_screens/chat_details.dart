import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/views/app/social_cubit.dart';

class ChatDetailsScreen extends StatelessWidget {
  final User user;

  ChatDetailsScreen({super.key, required this.user});

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit(),
      child: BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          // SocialCubit.get(context).getMessages(receiverId: user.uId!);
          var messages;
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(user.image!),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Text(user.name!)
                ],
              ),
            ),
            body:
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    messages.isNotEmpty ?
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message = messages[index];
                            // if (SocialCubit.get(context).model?.uId == message.senderId){
                            //   return buildMyMessage(message);
                            // }
                            // else {
                            //   return buildMessage(message);
                            // }
                          },
                          separatorBuilder: (context, index) => SizedBox(height: 15,),
                          itemCount: messages.length
                      ),
                    ) :
                    Expanded(child: Center(child: Text('no messages'),)),
                    // Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'type your message here...'),
                          ),
                        ),
                        Container(
                          height: 40,
                          color: Colors.blue,
                          child: MaterialButton(
                              onPressed: () {
                                // SocialCubit.get(context).sendMessage(
                                //     receiverId: user.uId!,
                                //     dateTime: DateTime.now().toString(),
                                //     text: messageController.text
                                // );
                                // messageController.text = '';
                              },
                              minWidth: 1,
                              child: const Icon(
                                Icons.send,
                                size: 16,
                                color: Colors.white,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              )
          );
        },
      ),
    );
  }

  Widget buildMessage(MessageModel message) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
              )),
          child: Text(message.text!, style: const TextStyle(fontSize: 18)),
        ),
      );

  Widget buildMyMessage(MessageModel message) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
              )),
          child: Text(
            message.text!,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
}
