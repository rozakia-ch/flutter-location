import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_location/logic/repository/location_repository.dart';
import 'package:location/location.dart';

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key? key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();

  LocationData? _location;
  late StreamSubscription<LocationData> _locationSubscription;
  String? _error;

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      setState(() {
        _error = err.code;
      });
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      LocationRepository().createLogLocation(currentLocation);
      print(currentLocation);
      setState(() {
        _error = null;

        _location = currentLocation;
      });
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Listen location: ' + (_error ?? '${_location ?? "unknown"}'),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: ElevatedButton(
                child: const Text('Listen'),
                onPressed: _listenLocation,
              ),
            ),
            ElevatedButton(
              child: const Text('Stop'),
              onPressed: _stopListen,
            )
          ],
        ),
      ],
    );
  }
}
