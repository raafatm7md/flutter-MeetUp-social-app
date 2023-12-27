import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/views/cubits/new_post/new_post_cubit.dart';

class NewPostScreen extends StatelessWidget {
  final User user;
  NewPostScreen({super.key, required this.user});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPostCubit(),
      child: BlocConsumer<NewPostCubit, NewPostState>(
        listener: (context, state) {
          if (state is UploadPostError){
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is UploadPostSuccess){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Post'),
              titleSpacing: 5.0,
              actions: [
                TextButton(
                    onPressed: () {
                      NewPostCubit.get(context).createPost(text: textController.text.trim());
                    },
                    child: const Text(
                      'post',
                      style: TextStyle(fontSize: 20.0),
                    )),
                const SizedBox(
                  width: 15.0,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is UploadPostLoading)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user.image ??
                            'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                          child: Text(
                        user.name!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.grey),
                      )),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(
                          hintText: 'what is in your mind?',
                          hintStyle: TextStyle(color: Colors.white30),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (NewPostCubit.get(context).postImage != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                image: FileImage(
                                    NewPostCubit.get(context).postImage!),
                                fit: BoxFit.cover,
                              )),
                        ),
                        IconButton(
                            onPressed: () {
                              NewPostCubit.get(context).removePostImage();
                            },
                            icon: const CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(
                                Icons.close, color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              NewPostCubit.get(context).getPostImage();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_outlined),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text('add photo')
                              ],
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
