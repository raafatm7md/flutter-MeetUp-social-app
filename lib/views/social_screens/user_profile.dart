import 'package:flutter/material.dart';
import 'package:social_app/models/all_users_model.dart';

import 'chat_details.dart';

class UserProfile extends StatelessWidget {
  final int myID;
  final Data user;
  const UserProfile({super.key, required this.myID, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(user.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 190.0,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0)),
                          image: DecorationImage(
                            image: NetworkImage(user.cover != null
                                ? '${user.cover}'
                                : 'https://e0.pxfuel.com/wallpapers/135/566/desktop-wallpaper-purple-for-purple-damask-peach-flock-by-for-your-mobile-tablet-explore-purple-damask-black-and-purple-purple-thumbnail.jpg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  CircleAvatar(
                    radius: 65.0,
                    backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(user.image !=
                          null
                          ? '${user.image}'
                          : 'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailsScreen(
                              myId: myID,
                              user: user,
                            ),
                          ));
                    },
                    child: Text('Chat'),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Center(
                  child: Text(
                    '${user.name} doesn\'t have posts yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
