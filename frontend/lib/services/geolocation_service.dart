import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Position? _lastPosition;
  double _distance = 0.0;
  Stream<Position>? _positionStream;

  GeolocationService() {
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw Exception('Location permissions denied');
    }
  }

  void startTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    );
    _positionStream?.listen((Position position) {
      if (_lastPosition != null) {
        _distance += Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        ) / 1000; // Convert meters to km
      }
      _lastPosition = position;
    });
  }

  double stopTracking() {
    _positionStream = null;
    final distance = _distance;
    _distance = 0.0; // Reset for next session
    _lastPosition = null;
    return distance;
  }

  double get currentDistance => _distance;
}