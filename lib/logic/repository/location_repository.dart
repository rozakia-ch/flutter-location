import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';

class LocationRepository {
  Future createLogLocation(position) async {
    final String apiURL = 'YOUR_API_URL';
    String? deviceId = await PlatformDeviceId.getDeviceId;
    try {
      var request = await http.post(
        Uri.parse(apiURL + "/create-log-position"),
        body: {
          'device_id': deviceId,
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );
      print(request.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future getAddress({double? latitude, double? longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!).then((value) => value);
      Placemark placeMark = placemarks.first;
      String? street = placeMark.street;
      // String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;
      String? subAdministrativeArea = placeMark.subAdministrativeArea;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? country = placeMark.country;
      String? address =
          "$street, $subLocality, $locality $postalCode, $subAdministrativeArea, $administrativeArea , $country";
      return address;
    } catch (e) {
      return e;
    }
  }
}
