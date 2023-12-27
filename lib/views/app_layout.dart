import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app/views/social_screens/notifications.dart';
import 'package:social_app/views/social_screens/search.dart';
import 'package:social_app/views/social_screens/weather.dart';
import '../services/shared.dart';
import 'cubits/app/social_cubit.dart';
import 'onboarding.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
        ..updateLocation()
        ..getAllPosts()
        ..getAllUserData()
        ..createMarkers(context),
      child: BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {
          if (state is SocialGetUserTokenError) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => OnBoardingScreen(),
                ),
                (route) => false);
            Fluttertoast.showToast(
                msg: 'Invalid token',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            CacheHelper.removeData('token');
          }
        },
        builder: (context, state) {
          RefreshController _refreshController =
              RefreshController(initialRefresh: false);
          var cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherScreen(
                                lat: '${cubit.user?.latitude}',
                                long: '${cubit.user?.longitude}'),
                          ));
                    },
                    icon: const Icon(Icons.wb_twighlight)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsScreen(),
                          ));
                    },
                    icon: const Icon(Icons.notifications_active_outlined)),
                IconButton(
                    onPressed: () {
                      if (cubit.user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                id: cubit.user!.id!,
                                myImg: cubit.user!.image ??
                                    'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg',
                              ),
                            ));
                      }
                    },
                    icon: const Icon(Icons.search_outlined)),
              ],
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: cubit.currentIndex != 3
                ? SmartRefresher(
                    enablePullDown: true,
                    header: MaterialClassicHeader(),
                    controller: _refreshController,
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 1000));
                      cubit.getUserData();
                      cubit.getAllUserData();
                      cubit.getAllPosts();
                      cubit.createMarkers(context);
                      _refreshController.refreshCompleted();
                    },
                    child: cubit.user != null
                        ? cubit.screens[cubit.currentIndex]
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  )
                : cubit.user != null
                    ? cubit.screens[cubit.currentIndex]
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: BottomNavigationBar(
                backgroundColor: Colors.grey[900],
                showUnselectedLabels: false,
                showSelectedLabels: false,
                currentIndex: cubit.currentIndex,
                onTap: (value) {
                  cubit.changeBottomNav(value);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat_outlined), label: 'Chat'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.insert_emoticon_outlined), label: 'AI'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_pin_circle_outlined),
                      label: 'Map'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_outlined), label: 'Profile'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
