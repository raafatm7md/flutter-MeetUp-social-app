import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/views/app/social_cubit.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..getUserData(),
      child: BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          UserModel? userModel = SocialCubit.get(context).model;
          var profileImage = SocialCubit.get(context).profileImage;
          var coverImage = SocialCubit.get(context).coverImage;

          nameController.text = userModel?.name ?? '';
          bioController.text = userModel?.bio ?? '';
          phoneController.text = userModel?.phone ?? '';

          return userModel != null
              ? Scaffold(
                  appBar: AppBar(
                    title: const Text('Edit Profile'),
                    titleSpacing: 5.0,
                    actions: [
                      TextButton(
                          onPressed: () {
                            SocialCubit.get(context).updateUser(
                                name: nameController.text,
                                phone: phoneController.text,
                                bio: bioController.text);
                          },
                          child: const Text('update', style: TextStyle(fontSize: 20.0))),
                      const SizedBox(
                        width: 15.0,
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (state is SocialUpdateUserLoading)
                            const LinearProgressIndicator(),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 190.0,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Container(
                                        height: 140,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0)),
                                            image: DecorationImage(
                                              image: coverImage == null
                                                  ? NetworkImage(
                                                      '${userModel.cover}')
                                                  : FileImage(coverImage)
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            SocialCubit.get(context)
                                                .getCoverImage();
                                          },
                                          icon: const CircleAvatar(
                                            radius: 20.0,
                                            child: Icon(Icons.camera_enhance),
                                          ))
                                    ],
                                  ),
                                ),
                                Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                      radius: 65.0,
                                      backgroundColor:
                                          Theme.of(context).scaffoldBackgroundColor,
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage: profileImage == null
                                            ? NetworkImage('${userModel.image}')
                                            : FileImage(profileImage)
                                                as ImageProvider,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          SocialCubit.get(context)
                                              .getProfileImage();
                                        },
                                        icon: const CircleAvatar(
                                          radius: 18.0,
                                          child: Icon(
                                            Icons.camera_enhance,
                                            size: 22,
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Name must not be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                label: Text("Name"),
                                prefixIcon: Icon(Icons.person)),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: bioController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Bio must not be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                label: Text("Bio"), prefixIcon: Icon(Icons.info)),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone number must not be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                label: Text("Phone Number"),
                                prefixIcon: Icon(Icons.phone)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) : const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
