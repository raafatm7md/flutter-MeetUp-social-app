import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/all_users_model.dart';
import 'package:social_app/views/cubits/search/search_cubit.dart';
import 'package:social_app/views/social_screens/user_profile.dart';

import 'chat_details.dart';

class SearchScreen extends StatelessWidget {
  final int id;
  SearchScreen({super.key, required this.id});

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          var searchRes = SearchCubit.get(context).searchRes;
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    height: 45.0,
                    child: TextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "search must be not empty";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        SearchCubit.get(context)
                            .searchUser(searchController.text.trim());
                      },
                      decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white24),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide.none),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.deepPurple,
                          )),
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                    itemBuilder: (context, index) => buildSearchItem(context, searchRes[index]),
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[800],
                      ),
                    ),
                    itemCount: searchRes.length)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchItem(context, Data user) => InkWell(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(user.image ??
                'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            user.name!,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    ),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(
              myID: id,
              user: user,
            ),
          ));
    },
  );
}
