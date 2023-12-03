import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/views/app/social_cubit.dart';
import 'package:social_app/views/social_screens/new_post.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit(),
      child: BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {
          if (state is SocialNewPost) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPostScreen(),
                ));
          }
        },
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active_outlined)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.search_outlined)),
              ],
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
              child: BottomNavigationBar(
                backgroundColor: Colors.grey[900],
                showUnselectedLabels: false,
                showSelectedLabels: false,
                currentIndex: cubit.currentIndex,
                onTap: (value) {
                  cubit.changeBottomNav(value);
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Chat'),
                  BottomNavigationBarItem(icon: Icon(Icons.add_outlined), label: 'Post'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_search_outlined), label: 'Users'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings_outlined), label: 'Settings'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
