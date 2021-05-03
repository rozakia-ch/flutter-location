import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/logic/cubit/location_cubit.dart';
import 'package:flutter_location/logic/models/pin_information.dart';
import 'package:flutter_location/presentation/widgets/drawer_app.dart';
import 'package:flutter_location/presentation/widgets/map_pin_info.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapsPage extends StatefulWidget {
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  Location _location = Location();
  LocationCubit _locationCubit = LocationCubit();
  GoogleMapController? _controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  bool _showInfo = false;
  PinInformation? _selectedPin;
  PinInformation? _sourcePinInfo;
  // for my drawn routes on the map

  Map<PolylineId, Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  String _googleApiKey = 'YouApiKey';

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 16,
  );

  void _onMapCreated(GoogleMapController controller) async {
    this._controller = controller;
    if (_controller != null) {
      LocationData _locationData = await _location.getLocation();
      double _latitudeDestination = _locationData.latitude! + sin(1 * pi / 6.0) / 20.0;
      double _longitudeDestination = _locationData.longitude! + cos(1 * pi / 6.0) / 20.0;
      PointLatLng _origin = PointLatLng(_locationData.latitude!, _locationData.longitude!);
      PointLatLng _destination = PointLatLng(_latitudeDestination, _longitudeDestination);
      _destinationMarker(latitude: _latitudeDestination, longitude: _longitudeDestination);
      _setPolylines(origin: _origin, destination: _destination);
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          new CameraPosition(
            target: LatLng(_locationData.latitude!, _locationData.longitude!),
            zoom: 18.00,
          ),
        ),
      );
    }
  }

  void _initialLocation() async {
    LocationData _locationData = await _location.getLocation();
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        new CameraPosition(
          target: LatLng(_locationData.latitude!, _locationData.longitude!),
          zoom: 18.00,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _locationCubit,
      child: Scaffold(
        drawer: DrawerApp(),
        appBar: AppBar(
          title: Text("Google Maps"),
        ),
        body: BlocListener<LocationCubit, LocationState>(
          bloc: _locationCubit,
          listener: (context, state) {
            if (state is LocationLoaded && _controller != null) {
              _updateMarker(locationData: state.locationData!, address: state.address);
            }
          },
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(_markers.values),
                polylines: Set<Polyline>.of(_polylines.values),
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                onTap: (LatLng location) {
                  setState(() {
                    _showInfo = false;
                  });
                },
              ),
              if (_showInfo) MapPinInfo(selectedPin: _selectedPin),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    heroTag: 'recenter',
                    onPressed: () {
                      _initialLocation();
                    },
                    child: Icon(
                      Icons.my_location,
                      color: Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Color(0xFFECEDF1))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMarker({required LocationData locationData, String? address}) {
    final LatLng _latlng = LatLng(locationData.latitude!, locationData.longitude!);
    _sourcePinInfo = PinInformation(
      locationName: "Your Location",
      location: _latlng,
      locationAddress: address,
      pinPath: "assets/driving_pin.png",
      avatarPath: "assets/friend1.jpg",
      labelColor: Colors.blueAccent,
    );
    final String _markerIdVal = 'marker_id_my_location';
    final MarkerId _markerId = MarkerId(_markerIdVal);
    final Marker marker = Marker(
      markerId: _markerId,
      position: _latlng,
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
      onTap: () => setState(() {
        _showInfo = true;
        _selectedPin = _sourcePinInfo;
      }),
    );
    setState(() {
      _markers[_markerId] = marker;
    });
  }

  void _destinationMarker({double? latitude, double? longitude}) {
    final LatLng _latlng = LatLng(latitude!, longitude!);
    _sourcePinInfo = PinInformation(
      locationName: "Your Location",
      location: _latlng,
      locationAddress: "destination",
      pinPath: "assets/driving_pin.png",
      avatarPath: "assets/friend1.jpg",
      labelColor: Colors.blueAccent,
    );
    final String _markerIdVal = 'marker_id_destination';
    final MarkerId _markerId = MarkerId(_markerIdVal);
    final Marker marker = Marker(
      markerId: _markerId,
      position: _latlng,
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      onTap: () => setState(() {
        _showInfo = true;
        _selectedPin = _sourcePinInfo;
      }),
    );
    setState(() {
      _markers[_markerId] = marker;
    });
  }

  void _setPolylines({required PointLatLng origin, required PointLatLng destination}) async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      _googleApiKey,
      origin,
      destination,
      travelMode: TravelMode.driving,
      avoidHighways: true,
      optimizeWaypoints: true,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: _polylineCoordinates);
    _polylines[id] = polyline;
  }

  @override
  dispose() {
    print("Disposing MapsPage");
    _locationCubit.close();
    super.dispose();
  }
}
