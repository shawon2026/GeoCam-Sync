import 'dart:math';

class DistanceHelper {
  DistanceHelper._();

  static double calculateMeters({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) {
    const earthRadiusMeters = 6371000.0;

    final lat1 = _toRadians(fromLatitude);
    final lon1 = _toRadians(fromLongitude);
    final lat2 = _toRadians(toLatitude);
    final lon2 = _toRadians(toLongitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusMeters * c;
  }

  static double _toRadians(double degree) => degree * pi / 180.0;
}
