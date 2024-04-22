import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final LatLng destination;

  MapScreen({required this.destination});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late Timer _timer;
  LatLng? initialLocation;
  LatLng? currentLocation;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  String apiKey =
      'AIzaSyBSaSZNd8RPSWMlPsu1qXN6F9r1aMxY2Kg'; // Ganti dengan kunci API Google Maps Anda

  String distance = '';
  String duration = '';

  // Tambahkan variabel untuk marker lokasi saat ini
  Marker? currentLocationMarker;

  // Tambahkan variabel mapLoaded
  bool mapLoaded = false;

  @override
  void initState() {
    super.initState();
    _getInitialLocation();

    // Panggil metode untuk memperbarui lokasi saat ini setiap 5 detik
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _updateCurrentLocation();
    });
  }

  @override
  void dispose() {
    // Membatalkan timer saat widget di dispose
    _timer.cancel();
    super.dispose();
  }

  Future<void> _getInitialLocation() async {
    // Mendapatkan lokasi awal dari GPS
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Menetapkan lokasi awal ke lokasi GPS saat ini
    initialLocation = LatLng(position!.latitude, position.longitude);

    // Menginisialisasi peta dengan lokasi awal
    _addMarker(initialLocation!, 'origin', 'Lokasi Awal');
    _addMarker(widget.destination, 'destination', 'Tujuan');

    // Mengatur rute awal
    _setRoute();
  }

  // Metode untuk memperbarui lokasi saat ini
  Future<void> _updateCurrentLocation() async {
    Position? newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(newPosition!.latitude, newPosition.longitude);
      // Update marker untuk lokasi saat ini
      _updateCurrentLocationMarker(currentLocation!);
      // Mengatur rute dengan lokasi saat ini sebagai titik awal
      _setRoute();

      // Panggil _recenterMap jika peta telah dimuat
      if (mapLoaded) {
        _recenterMap(currentLocation!);
      }
    });
  }

  // Metode untuk menambah/memperbarui marker lokasi saat ini
  void _updateCurrentLocationMarker(LatLng position) {
    _markers.removeWhere((marker) => marker.markerId.value == 'current');
    currentLocationMarker = Marker(
      markerId: MarkerId('current'),
      position: position,
      infoWindow: InfoWindow(title: 'Lokasi Anda'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    _markers.add(currentLocationMarker!);
  }

  // Metode untuk menambah marker
  void _addMarker(LatLng position, String markerId, String title) {
    Set<Marker> markers = _markers;
    markers.add(Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title),
    ));

    setState(() {
      _markers = markers;
    });
  }

  // Metode untuk mengatur rute
  Future<void> _setRoute() async {
    String url =
        'https://routes.googleapis.com/directions/v2:computeRoutes?key=$apiKey';

    Map<String, dynamic> requestBody = {
      'origin': {
        'location': {
          'latLng': {
            'latitude': initialLocation!.latitude,
            'longitude': initialLocation!.longitude,
          }
        }
      },
      'destination': {
        'location': {
          'latLng': {
            'latitude': widget.destination.latitude,
            'longitude': widget.destination.longitude,
          }
        }
      },
      'travelMode': 'DRIVE',
      'routingPreference': 'TRAFFIC_AWARE',
      'departureTime': DateTime.now().toUtc().toIso8601String(),
      'computeAlternativeRoutes': true,
      'routeModifiers': {
        'avoidTolls': false,
        'avoidHighways': false,
        'avoidFerries': false,
      },
      'languageCode': 'en-US',
      'units': 'IMPERIAL'
    };

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
        },
        body: json.encode(requestBody));

    print("data"+response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        List<LatLng> points = [];

        // Decode the polyline
        String encodedPolyline = data['routes'][0]['polyline']['encodedPolyline'];
        points = _decodePolyline(encodedPolyline);

        // Add polyline to _polylines
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          points: points,
          width: 5,
        ));

        // Extract distance and duration
        distance = (data['routes'][0]['distanceMeters'] / 1000).toStringAsFixed(2); // Convert meters to kilometers
        String durationString = data['routes'][0]['duration'];
        String durationWithoutSuffix = durationString.replaceAll('s', ''); // Remove 's'
        int durationInSeconds = int.tryParse(durationWithoutSuffix) ?? 0; // Parse to integer, default to 0 if parsing fails
        print(durationInSeconds); // Output: 567

        int hours = durationInSeconds ~/ 3600;
        int minutes = (durationInSeconds % 3600) ~/ 60;
        duration = '$hours jam $minutes menit'; // Format duration as "X jam Y menit"

        setState(() {});
      }
    }
  }


  // Metode untuk mengonstruksi polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
  }

  // Metode untuk menggerakkan kamera ke lokasi saat ini
  void _recenterMap(LatLng position) {
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  // Metode untuk menangani pembuatan peta
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      mapLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: initialLocation != null
          ? Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialLocation!,
                zoom: 15,
              ),
              onMapCreated: _onMapCreated,
              polylines: _polylines,
              markers: _markers,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Distance: $distance km'),
                Text('Duration: $duration'),
              ],
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
