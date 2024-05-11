import 'package:geolocator/geolocator.dart';
import 'package:vgp/models/exceptions/base_exception.dart';
import 'package:vgp/resources/utils/helpers/helper_mixin.dart';

class GeolocationViewModel with HelperMixin {
  Future<bool> isEnableGps() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw BaseException(message: 'Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw BaseException(
          message:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 10)
          );
    } catch (e) {
      print(e);
      try {
        return (await Geolocator.getLastKnownPosition())!;
      } catch (e) {
        print(e);
      }
      throw BaseException(message: "Unexpected error.");
    }
  }

  double distanceBetween(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}
