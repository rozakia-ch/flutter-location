import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_location/logic/repository/location_repository.dart';
import 'package:location/location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  // ignore: cancel_subscriptions
  late StreamSubscription<LocationData> _locationSubscription;
  final Location _location = Location();
  final LocationRepository _locationRepository = LocationRepository();
  LocationCubit() : super(LocationInitial()) {
    _checkPermissions();
    locationStream();
  }

  Future<void> locationStream() async {
    _location.changeSettings(interval: 5000);
    Future.delayed(const Duration(milliseconds: 1000), () => _checkBackgroundMode());
    _locationSubscription = _location.onLocationChanged.handleError((dynamic err) {
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      _listenLocation(currentLocation);
    });
  }

  void _listenLocation(currentLocation) async {
    String? address = await _locationRepository.getAddress(
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );
    await _locationRepository.createLogLocation(currentLocation);
    emit(LocationLoaded(locationData: currentLocation, address: address));
  }

  void _checkPermissions() async {
    PermissionStatus _permission = await _location.hasPermission();
    if (_permission != PermissionStatus.granted) await _location.requestPermission();
  }

  void _checkBackgroundMode() async {
    final bool result = await _location.isBackgroundModeEnabled();
    if (!result) await _location.enableBackgroundMode(enable: true);
    _location.changeNotificationOptions(
      channelName: "Location background service",
      title: "Location background service",
      subtitle: "Location background service is running",
      iconName: "location",
    );
  }

  @override
  Future<void> close() async {
    _locationSubscription.cancel();
    _location.enableBackgroundMode(enable: false);
    return super.close();
  }
}
