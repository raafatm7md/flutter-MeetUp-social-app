import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_app/views/app/social_cubit.dart';
import 'package:social_app/views/app/social_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var user = SocialCubit.get(context).user;
        return FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            initialCenter: LatLng(user!.latitude!.toDouble(), user.longitude!.toDouble()),
            initialZoom: 7.0,
            cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  LatLng(-90, -180),
                  LatLng(90, 180),
                )),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            )
          ],
        );
      },
    );
  }
}
