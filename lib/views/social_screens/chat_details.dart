import 'dart:convert';

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
  final List<Message> messages = [];
  String? roomId;
  IO.Socket? socket;
  bool typing = false;

  @override
  void initState() {
    super.initState();
    List<int> ids = [widget.myId, widget.user.id!];
    ids.sort();
    roomId = ids.join();
    connectSocket();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    messages.length > 0
                        ? Expanded(
                            child: SingleChildScrollView(
                              reverse: true,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var message = messages[index];
                                    if ('${widget.myId}' == message.auther) {
                                      return buildMyMessage(message);
                                    } else {
                                      return buildMessage(message);
                                    }
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 15,
                                      ),
                                  itemCount: messages.length),
                            ),
                          )
                        : Expanded(
                            child: Center(
                            child: Text(
                              'no messages',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )),
                    typing? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${widget.user.name} is typing ...', style: TextStyle(color: Colors.white)),
                    ):
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              onFieldSubmitted: (value) {
                                sendMessage().then((value) {
                                  if (value == true) {
                                    Future.delayed(Duration(milliseconds: 5000))
                                        .then((value) {
                                      socket?.emit('fetch_messages', roomId);
                                    });
                                  }
                                });
                                messageController.clear();
                              },
                              onChanged: (value) {
                                socket?.emit('typing', roomId);
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(50)),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsetsDirectional.only(
                                      start: 20.0, end: 10.0),
                                  hintText: 'type your message here...'),
                            ),
                          ),
                          MaterialButton(
                              onPressed: () {
                                sendMessage().then((value) {
                                  if (value == true) {
                                    Future.delayed(Duration(milliseconds: 5000))
                                        .then((value) {
                                      socket?.emit('fetch_messages', roomId);
                                    });
                                  }
                                });
                                messageController.clear();
                              },
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

  Widget buildMessage(Message message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
              )),
          child: Text(message.message!,
              style: const TextStyle(fontSize: 22, color: Colors.white)),
        ),
      );

  Widget buildMyMessage(Message message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
              )),
          child: Text(
            message.message!,
            style: const TextStyle(fontSize: 22, color: Colors.white),
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

      socket?.on('joined', (data) => print(data));

      socket?.on('reseve_message', (data) {
        socket?.emit('fetch_messages', roomId);
      });

      socket?.on('user_typing', (data) {
        setState(() {
          typing = true;
        });
        Future.delayed(Duration(seconds: 2)).then((value) {
          setState(() {
            typing = false;
          });
        });
      });

      socket?.on('display_messages', (data) {
        messages.clear();
        AllMessages res = AllMessages.fromJson(data);
        res.allMessages?.forEach((element) {
          setState(() {
            messages.add(element);
          });
        });
      });

      socket?.emit('join_room', roomId);
      socket?.emit('fetch_messages', roomId);
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

  Future<bool> sendMessage() async {
    String message = messageController.text.trim();
    if (message.isEmpty) return false;
    Map messageMap = {
      'message': message,
      'auther': widget.myId,
      'id': roomId,
    };
    socket?.emit('send_message', messageMap);
    socket?.emit('fetch_messages', roomId);
    return true;
  }
}
