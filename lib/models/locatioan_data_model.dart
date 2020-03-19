import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Location({this.latitude, this.longitude});

  Future<double> calculateDistance(List<double> userCoord) async {
    double distanceInMeters = await Geolocator().distanceBetween(
        userCoord[0], userCoord[1], this.latitude, this.longitude);

    return distanceInMeters / 1000;
  }
}
