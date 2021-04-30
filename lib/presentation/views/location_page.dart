import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_location/logic/cubit/location_cubit.dart';
import 'package:flutter_location/presentation/methods/app_method.dart';
import 'package:flutter_location/presentation/widgets/drawer_app.dart';
import 'package:location/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Location location = Location();
  final LocationCubit _locationCubit = LocationCubit();

  @override
  void initState() {
    _checkPermissions();
    _checkBackgroundMode();
    location.changeNotificationOptions(
      channelName: "Location background service",
      title: "Location background service",
      subtitle: "Location background service is running",
      iconName: "location",
    );
    super.initState();
  }

  Future<void> _checkPermissions() async {
    PermissionStatus _permission = await location.hasPermission();
    if (_permission != PermissionStatus.granted) await location.requestPermission();
  }

  Future<void> _checkBackgroundMode() async {
    final bool result = await location.isBackgroundModeEnabled();
    if (!result) await location.enableBackgroundMode(enable: true);
  }

  double? _latitude, _longitude;
  String? _accuracy = "0", _address = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text("Location Stream Bloc"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => AppMethod().showInfoDialog(context),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => _locationCubit,
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationLoaded) {
              _latitude = state.locationData!.latitude;
              _longitude = state.locationData!.longitude;
              _accuracy = state.locationData!.accuracy!.toStringAsFixed(2);
              _address = state.address;
            }

            return ListView(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Address: "),
                    SizedBox(width: 10),
                    Expanded(child: Text(_address!)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Latitude: "),
                    Text(_latitude.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Longitude: "),
                    Text(_longitude.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Accuracy: "),
                    Text(_accuracy!),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    location.enableBackgroundMode(enable: false);
    _locationCubit.close();
  }
}
