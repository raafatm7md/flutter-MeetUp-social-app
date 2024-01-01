import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:social_app/views/cubits/app/social_cubit.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool typing = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var _chatHistory = SocialCubit.get(context).chatBotHistory;

        void getAnswer() async {
          setState(() {
            typing = true;
          });
          final url = "https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=AIzaSyBDCFG3Y2bZvvDdP5UPrBrjvqjeHskbYP0";
          final uri = Uri.parse(url);
          List<Map<String,String>> msg = [];
          for (var i = 0; i < _chatHistory.length; i++) {
            msg.add({"content": _chatHistory[i]["message"]});
          }

          Map<String, dynamic> request = {
            "prompt": {
              "messages": [msg]
            },
            "temperature": 0.25,
            "candidateCount": 1,
            "topP": 1,
            "topK": 1
          };

          try{
            final response = await http.post(uri, body: jsonEncode(request));
            setState(() {
              _chatHistory.add({
                "time": DateTime.now(),
                "message": json.decode(response.body)["candidates"][0]["content"],
                "isSender": false,
              });
              typing = false;
            });
          } catch (e){
            setState(() {
              typing = false;
            });
          }

          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }

        return Scaffold(
          body: Column(
            children: [
              CircleAvatar(
                radius: 70.0,
                backgroundImage: NetworkImage('https://1.bp.blogspot.com/-l8k38cvj-Ys/XFsLYyTWjrI/AAAAAAAAAjk/dizN5Z9rA14jYvkKgOcJWpo1RvmUsq1qwCLcBGAs/s1600/bot.png'),
              ),
              Text('MeetAI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: ListView.builder(
                    itemCount: _chatHistory.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (_chatHistory[index]["isSender"]
                              ? Alignment.topRight
                              : Alignment.topLeft),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: (_chatHistory[index]["isSender"]
                                  ? Colors.deepPurple
                                  : Colors.white),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(_chatHistory[index]["message"],
                                style: TextStyle(
                                    fontSize: 15,
                                    color: _chatHistory[index]["isSender"]
                                        ? Colors.white
                                        : Colors.black)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (typing) Text('   Typing ...', style: TextStyle(color: Colors.white),),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _chatController,
                            onFieldSubmitted: (value) {
                              setState(() {
                                if (_chatController.text.isNotEmpty) {
                                  _chatHistory.add({
                                    "time": DateTime.now(),
                                    "message": _chatController.text,
                                    "isSender": true,
                                  });
                                  _chatController.clear();
                                }
                              });
                              _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent,
                              );

                              getAnswer();
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
                                hintText: 'Ask about any thing 🤖'),
                          ),
                        ),
                        MaterialButton(
                            onPressed: () {
                              setState(() {
                                if (_chatController.text.isNotEmpty) {
                                  _chatHistory.add({
                                    "time": DateTime.now(),
                                    "message": _chatController.text,
                                    "isSender": true,
                                  });
                                  _chatController.clear();
                                }
                              });
                              _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent,
                              );

                              getAnswer();
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
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
