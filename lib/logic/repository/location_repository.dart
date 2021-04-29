import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';

class LocationRepository {
  Future createLogLocation(position) async {
    final String apiURL = 'YOUR_API_URL';
    String? deviceId = await PlatformDeviceId.getDeviceId;
    // print(deviceId);
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
}
