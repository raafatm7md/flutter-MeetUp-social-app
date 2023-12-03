import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/views/app/social_cubit.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..getUserData(),
      child: BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          UserModel? model = SocialCubit.get(context).model;

          return model != null
              ? Scaffold(
            appBar: AppBar(
              title: const Text('Add Post'),
              titleSpacing: 5.0,
              actions: [
                TextButton(
                    onPressed: () {
                      var now = DateTime.now();
                      if (SocialCubit.get(context).postImage == null) {
                        SocialCubit.get(context).createPost(
                            dateTime: now.toString(),
                            text: textController.text);
                      } else {
                        SocialCubit.get(context).uploadPost(
                            dateTime: now.toString(),
                            text: textController.text);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('post', style: TextStyle(fontSize: 20.0),)),
                const SizedBox(
                  width: 15.0,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is SocialPostLoading)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(model!.image!),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(child: Text(model.name!, style:  TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0
                      ),)),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(
                          hintText: 'what is in your mind?',
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  if (SocialCubit.get(context).postImage != null)
                    Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: FileImage(SocialCubit.get(context).postImage!),
                              fit: BoxFit.cover,
                            )),
                      ),
                      IconButton(onPressed: () {
                        SocialCubit.get(context).removePostImage();
                      }, icon: const CircleAvatar(
                        radius: 20.0,
                        child: Icon(
                          Icons.close,
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              SocialCubit.get(context).getPostImage();
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
                      Expanded(
                        child: TextButton(
                            onPressed: () {}, child: const Text('# tags')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ): const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
