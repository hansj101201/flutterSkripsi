import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  final LatLng destination;

  MapScreen({required this.destination});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  LatLng? initialLocation;
  LatLng? currentLocation;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  late PolylinePoints polylinePoints;
  String apiKey =
      'AIzaSyAfh6f28kinUzZ36OcmqEzEPMtloxF1UGw';

  late Timer timer;

  String? estimatedTime;

  late LatLngBounds visibleBounds; // Define visibleBounds here

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
    _getInitialLocation();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateCurrentLocationMarker();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> _addPolylineFromCurrentLocation() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
      PointLatLng(widget.destination.latitude, widget.destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.status == 'OK') {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5,
        ));
        estimatedTime = result.durationText;
      });
    }
  }

  Future<void> _getInitialLocation() async {
    Position? position = await Geolocator.getLastKnownPosition();
    setState(() {
      initialLocation = LatLng(position!.latitude, position.longitude);
      currentLocation = initialLocation;
      _addMarker(initialLocation!, 'currentLocation', 'Lokasi Saat Ini',
          BitmapDescriptor.defaultMarker);
      _addMarker(
          widget.destination,
          'destination',
          'Tujuan',
          BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure));
      _addPolyline(); // Add this
    });
  }

  void _updateCurrentLocationMarker() async {
    Position position =
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      _addMarker(currentLocation!, 'currentLocation', 'Lokasi Saat Ini',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));
      if (_isOutsidePolyline(currentLocation!)) {
        _addPolylineFromCurrentLocation(); // Add this
      }
    });

    _recenterMapIfNeeded(); // Add this
  }

  bool _isOutsidePolyline(LatLng currentLocation) {
    if (polylineCoordinates.isEmpty) return true; // If there is no polyline yet
    for (LatLng point in polylineCoordinates) {
      if (calculateDistance(point, currentLocation) < 0.1) { // Adjust threshold distance as needed
        return false;
      }
    }
    return true;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    return sqrt(pow(point1.latitude - point2.latitude, 2) + pow(point1.longitude - point2.longitude, 2));
  }

  void _addMarker(
      LatLng position, String markerId, String title, BitmapDescriptor icon) {
    _markers.removeWhere((m) => m.markerId.value == markerId);
    _markers.add(Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title),
      icon: icon,
    ));
  }

  Future<void> _addPolyline() async {
    _polylines.clear(); // Clear all polylines before adding a new one

    if (initialLocation != null && currentLocation != null) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(initialLocation!.latitude, initialLocation!.longitude),
        PointLatLng(widget.destination.latitude, widget.destination.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.status == 'OK') {
        polylineCoordinates.clear(); // Clear polyline coordinates before adding new ones
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        print('Status: ${result.status}');
        print('Duration Text: ${result.durationText}');
        print('Distance Text: ${result.distanceText}');
        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 5,
          ));
          estimatedTime = result.durationText; // Handle null case
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _recenterMapIfNeeded() {
    if (!_isLocationVisible(currentLocation!, visibleBounds)) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(currentLocation!),
      );
    }
  }

  bool _isLocationVisible(LatLng location, LatLngBounds bounds) {
    return bounds.contains(location);
  }

  void _onCameraIdle() {
    // Update visible bounds when camera is idle
    mapController.getVisibleRegion().then((visibleRegion) {
      setState(() {
        visibleBounds = visibleRegion;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Example'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialLocation!,
              zoom: 20,
            ),
            onMapCreated: _onMapCreated,
            markers: Set.from(_markers),
            polylines: _polylines,
            onCameraIdle: _onCameraIdle,
          ),
          if (estimatedTime != null) // Display estimated time if available
            Positioned(
              top: AppBar().preferredSize.height + 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimasi waktu ke tujuan:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        estimatedTime!,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

