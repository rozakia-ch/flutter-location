import 'package:flutter/material.dart';
import 'package:flutter_location/logic/cubit/location_cubit.dart';
import 'package:flutter_location/presentation/widgets/drawer_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LocationCubit _locationCubit = LocationCubit();
  double? _latitude, _longitude;
  String? _accuracy = "0", _address = "";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _locationCubit,
      child: Scaffold(
        drawer: DrawerApp(),
        appBar: AppBar(
          title: Text("Location Stream Bloc"),
        ),
        body: BlocBuilder<LocationCubit, LocationState>(
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
                ElevatedButton(
                  onPressed: () => _locationCubit.close(),
                  child: Text("Stop Listen"),
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
    _locationCubit.close();
    print("Disposing Location Page");
    super.dispose();
  }
}
