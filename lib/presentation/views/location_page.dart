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
  final TextStyle textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
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

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/pin.png",
                    fit: BoxFit.fitWidth,
                    width: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_address!, textAlign: TextAlign.center, style: textStyle),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Latitude: ',
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: _latitude.toString(),
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Longitude: ',
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: _longitude.toString(),
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Accuracy: ',
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: _accuracy,
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
