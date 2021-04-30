import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_location/logic/repository/location_repository.dart';
import 'package:location/location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  // ignore: cancel_subscriptions
  StreamSubscription? locationStreamSubscription;
  final Location? location = Location();

  LocationData? locationData;
  LocationCubit() : super(LocationInitial()) {
    locationStream();
  }
  StreamSubscription<LocationData> locationStream() {
    location!.changeSettings(interval: 10000);
    return locationStreamSubscription = location!.onLocationChanged.handleError((dynamic err) {
      locationStreamSubscription!.cancel();
    }).listen((LocationData currentLocation) {
      setLocation(currentLocation);
    });
  }

  Future<void> setLocation(currentLocation) async {
    String? address = await LocationRepository()
        .getAddress(latitude: currentLocation.latitude, longitude: currentLocation.longitude);
    await LocationRepository().createLogLocation(currentLocation);
    emit(LocationLoaded(locationData: currentLocation, address: address));
  }

  @override
  Future<void> close() {
    locationStreamSubscription!.cancel();
    return super.close();
  }
}
