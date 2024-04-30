import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_skripsi/ApiKeys.dart';
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
  String apiKey = ApiKeys.googleMapsApiKey;
  String distance = '';
  String duration = '';
  Marker? currentLocationMarker;
  bool mapLoaded = false;
  bool isCurrentLocationInsideScreen = true;

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
      _updateCurrentLocationMarker(currentLocation!);
      _setRoute();

      if (mapLoaded && !isCurrentLocationInsideScreen) {
        _recenterMap(currentLocation!);
        isCurrentLocationInsideScreen = true; // Setel kembali status
      }
    });

    if (!isCurrentLocationInsideScreen) {
      _checkCurrentLocationInsideScreen();
    }
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

        _polylines.clear(); // Perbarui polyline
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

  // Metode untuk memeriksa apakah current location berada di dalam layar
  Future<void> _checkCurrentLocationInsideScreen() async {
    if (currentLocation != null && mapController != null) {
      final screenCoordinate = await mapController.getScreenCoordinate(currentLocation!);
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      if (screenCoordinate.x < 0 || screenCoordinate.x > screenWidth ||
          screenCoordinate.y < 0 || screenCoordinate.y > screenHeight) {
        isCurrentLocationInsideScreen = false;
      } else {
        isCurrentLocationInsideScreen = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: initialLocation != null
          ? Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialLocation!,
                    zoom: 15,
                  ),
                  onMapCreated: _onMapCreated,
                  polylines: _polylines,
                  markers: _markers,
                  myLocationEnabled: true,
                  onCameraMove: (CameraPosition position) {
                    // Ubah status current location berada di dalam layar saat pengguna memindahkan peta
                    isCurrentLocationInsideScreen = true;
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: null,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Recentralisasi peta ketika tombol ditekan
                      if (currentLocation != null) {
                        _recenterMap(currentLocation!);
                      }
                    },
                    child: Icon(Icons.my_location),
                  ),
                ),
              ],
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