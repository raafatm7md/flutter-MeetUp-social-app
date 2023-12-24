import 'package:flutter/material.dart';
import 'package:social_app/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/all_users_model.dart';

class ChatDetailsScreen extends StatefulWidget {
  final Data user;
  final int myId;
  ChatDetailsScreen({super.key, required this.myId, required this.user});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController messageController = TextEditingController();
  String? roomId;
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    connectSocket();
    List<int> ids = [widget.myId, widget.user.id!];
    ids.sort();
    roomId = ids.join();
  }

  @override
  void dispose() {
    super.dispose();
    socket?.disconnect();
    socket?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(widget.user.image ??
                    'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                widget.user.name!,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        body: socket!.connected
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    false
                        ? Expanded(
                            child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // var message = messages[index];
                                  // if (SocialCubit.get(context).model?.uId == message.senderId){
                                  //   return buildMyMessage(message);
                                  // }
                                  // else {
                                  //   return buildMessage(message);
                                  // }
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 15,
                                    ),
                                itemCount: 10),
                          )
                        : Expanded(
                            child: Center(
                            child: Text(
                              'no messages',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(50)),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsetsDirectional.only(start: 20.0, end: 10.0),
                                  hintText: 'type your message here...'),
                            ),
                          ),
                          MaterialButton(
                              onPressed: () {},
                              minWidth: 1,
                              color: Colors.deepPurple,
                              height: 50,
                              shape: CircleBorder(),
                              child: const Icon(
                                Icons.send_rounded,
                                size: 18,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget buildMessage(MessageModel message) => Align(
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

  Widget buildMyMessage(MessageModel message) => Align(
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

  connectSocket() {
    socket = IO.io('https://social-app-chat.onrender.com', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket?.connect();
    socket?.onConnect((data) {
      print('Connection established');
      setState(() {});
    });
    socket?.onConnectError((data) {
      print('Connect Error: $data');
      setState(() {});
    });
    socket?.onDisconnect((data) {
      print('Socket.IO server disconnected');
    });
  }
}
