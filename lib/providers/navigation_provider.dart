import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NavigationProvider extends ChangeNotifier {
  bool _isNavigationEnabled = false;
  Map<String, double>? _currentLocation;

  bool get isNavigationEnabled => _isNavigationEnabled;
  Map<String, double>? get currentLocation => _currentLocation;

  Future<void> toggleNavigation(bool value) async {
    if (value != _isNavigationEnabled) {
      _isNavigationEnabled = value;
      if (value) {
        await _requestPermissionAndGetLocation();
      } else {
        _currentLocation = null;
      }
      notifyListeners();
    }
  }

  Future<void> _requestPermissionAndGetLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Optionally, disable navigation or show dialog
          _isNavigationEnabled = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle permanently denied
        _isNavigationEnabled = false;
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _currentLocation = {
          'lat': position.latitude,
          'lng': position.longitude,
        };
      }
    } catch (e) {
      // Handle location service errors
      print('Location error: $e');
      _currentLocation = null;
    }
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    if (_isNavigationEnabled) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _currentLocation = {
          'lat': position.latitude,
          'lng': position.longitude,
        };
        notifyListeners();
      } catch (e) {
        print('Failed to get current location: $e');
      }
    }
  }
}
