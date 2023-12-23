import 'package:flutter/material.dart';

Widget searchResultBuild(list) => list.isEmpty
    ? Center(
        child: CircularProgressIndicator(),
      )
    : ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      // backgroundImage: NetworkImage(user.image!),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      'user.name!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
        itemCount: list.length);
