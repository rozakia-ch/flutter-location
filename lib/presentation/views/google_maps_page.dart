import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location/logic/cubit/location_cubit.dart';
import 'package:flutter_location/logic/models/pin_information.dart';
import 'package:flutter_location/presentation/widgets/drawer_app.dart';
import 'package:flutter_location/presentation/widgets/map_pin_info.dart';
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
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 16,
  );

  void _onMapCreated(GoogleMapController controller) {
    this._controller = controller;
    if (_controller != null) _initialLocation();
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
      onTap: () {
        setState(() {
          _showInfo = true;
          _selectedPin = _sourcePinInfo;
        });
      },
    );
    setState(() {
      _markers[_markerId] = marker;
    });
  }

  @override
  dispose() {
    print("Disposing MapsPage");
    _locationCubit.close();
    super.dispose();
  }
}
