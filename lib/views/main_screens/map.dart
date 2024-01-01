import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_app/models/map_style.dart';
import 'package:social_app/views/cubits/app/social_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var users = SocialCubit.get(context).mapUsers;

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: users[0]['position'],
                zoom: 11,
              ),
              markers: SocialCubit.get(context).mapMarkers,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                controller.setMapStyle(MapStyle().dark);
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            Positioned(
                bottom: 5,
                left: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        _controller.moveCamera(CameraUpdate.newLatLng(users[index]['position']));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                                radius: 35,
                                child: CircleAvatar(backgroundImage: NetworkImage(users[index]['image']), radius: 30)),
                            Text(users[index]['name'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)
                          ],
                        ),
                      ),
                    ),),
                ))
          ],
        );
      },
    );
  }
}
