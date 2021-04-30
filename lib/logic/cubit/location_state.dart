part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();
}

class LocationInitial extends LocationState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LocationLoaded extends LocationState {
  LocationData? locationData;
  String? address;
  LocationLoaded({this.locationData, this.address});
  @override
  List<Object?> get props => [locationData, address];
}
