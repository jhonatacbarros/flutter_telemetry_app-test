import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class TelemetryProvider extends ChangeNotifier {
  
  Position? _currentPosition;
  double _speed = 0.0;
  double _heading = 0.0;
  
   double _accelerationX = 0.0;
  double _accelerationY = 0.0;
  double _accelerationZ = 0.0;
  double _accelerationMagnitude = 0.0;
  
 
  bool _isTracking = false;
  String _status = 'Stopped';
  
 
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  
 
  Position? get currentPosition => _currentPosition;
  double get speed => _speed;
  double get heading => _heading;
  double get accelerationX => _accelerationX;
  double get accelerationY => _accelerationY;
  double get accelerationZ => _accelerationZ;
  double get accelerationMagnitude => _accelerationMagnitude;
  bool get isTracking => _isTracking;
  String get status => _status;
  
 
  Future<void> startTracking() async {
    if (_isTracking) return;
    
    try {
      _updateStatus('Checking permissions...');
      
     
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _updateStatus('Location services are disabled');
        return;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _updateStatus('Location permissions denied');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _updateStatus('Location permissions permanently denied');
        return;
      }
      
      _updateStatus('Starting tracking...');
      _isTracking = true;
      
      
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,  
      );
      
 
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _currentPosition = position;
          _speed = position.speed * 3.6; 
          _heading = position.heading;
          _updateStatus('Tracking active');
          notifyListeners();
        },
        onError: (error) {
          _updateStatus('Location error: $error');
        },
      );
      
      
      _accelerometerSubscription = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          _accelerationX = event.x;
          _accelerationY = event.y;
          _accelerationZ = event.z;
          
         
          _accelerationMagnitude = sqrt(
            pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)
          );
          
          notifyListeners();
        },
        onError: (error) {
          _updateStatus('Accelerometer error: $error');
        },
      );
      
      _updateStatus('Tracking active');
      notifyListeners();
      
    } catch (e) {
      _updateStatus('Error starting tracking: $e');
      _isTracking = false;
      notifyListeners();
    }
  }
  
   
  void stopTracking() {
    if (!_isTracking) return;
    
    _isTracking = false;
    _positionStreamSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _positionStreamSubscription = null;
    _accelerometerSubscription = null;
    
    _updateStatus('Stopped');
    notifyListeners();
  }
  
  
  Future<void> getCurrentLocation() async {
    try {
      _updateStatus('Getting current location...');
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _updateStatus('Location services disabled');
        return;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _updateStatus('Location permissions denied');
          return;
        }
      }
      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      _currentPosition = position;
      _speed = position.speed * 3.6;
      _heading = position.heading;
      _updateStatus('Location acquired');
      notifyListeners();
      
    } catch (e) {
      _updateStatus('Error getting location: $e');
    }
  }
  
  void _updateStatus(String newStatus) {
    _status = newStatus;
    debugPrint('Telemetry Status: $newStatus');
  }
  
  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
  
 
  String get formattedSpeed => '${_speed.toStringAsFixed(1)} km/h';
  String get formattedHeading => '${_heading.toStringAsFixed(0)}°';
  String get formattedAcceleration => '${_accelerationMagnitude.toStringAsFixed(2)} m/s²';
  String get formattedCoordinates => 
    _currentPosition != null 
      ? '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'
      : 'No location';
}