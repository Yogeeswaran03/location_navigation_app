import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFFF4F4F9),
      ),
      home: LocationNavigationPage(),
    );
  }
}

class LocationNavigationPage extends StatefulWidget {
  @override
  _LocationNavigationPageState createState() => _LocationNavigationPageState();
}

class _LocationNavigationPageState extends State<LocationNavigationPage> {
  late GoogleMapController _mapController;
  late Position _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng _destination = LatLng(9.914606, 78.122604); 
  late PolylinePoints _polylinePoints;
  TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints();
    _getCurrentLocation();
  }

  // Function to get the user's current location
  Future<void> _getCurrentLocation() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'You are here'),
          ),
        );
        _markers.add(
          Marker(
            markerId: MarkerId('destination'),
            position: _destination,
            infoWindow: InfoWindow(title: 'Destination'),
          ),
        );
      });
      _getRoute();
    } else {
      print('Location permission denied');
    }
  }

  // Function to get the route between the current location and destination
  Future<void> _getRoute() async {
    List<LatLng> route = await _getRouteCoordinates(
      LatLng(_currentPosition.latitude, _currentPosition.longitude),
      _destination,
    );
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: route,
          width: 5,
          color: Colors.blue,
        ),
      );
    });
  }

  // Function to fetch route coordinates between two points
  Future<List<LatLng>> _getRouteCoordinates(LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      'Your_Google_Maps_API_Key',
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    return polylineCoordinates;
  }

  // Function to start navigation in an external map (Google Maps)
  void _startNavigation() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition.latitude},${_currentPosition.longitude}&destination=${_destination.latitude},${_destination.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not open Google Maps.');
    }
  }

  // Function to handle the destination input
  Future<void> _updateDestination() async {
    if (_destinationController.text.isNotEmpty) {
      try {
        List<Location> locations =
        await locationFromAddress(_destinationController.text);
        if (locations.isNotEmpty) {
          setState(() {
            _destination = LatLng(locations[0].latitude, locations[0].longitude);
            _markers.removeWhere(
                    (marker) => marker.markerId.value == 'destination');
            _markers.add(
              Marker(
                markerId: MarkerId('destination'),
                position: _destination,
                infoWindow: InfoWindow(title: _destinationController.text),
              ),
            );
          });
          _getRoute();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Destination not found')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Location and Navigation',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF4CAF50),
          elevation: 5,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter Destination',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Color(0xFF4CAF50)),
                    onPressed: _updateDestination,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(9.939093, 78.121719),
                  zoom: 12,
                ),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _startNavigation,
          backgroundColor: Colors.green,
          elevation: 5,
          child: Icon(Icons.navigation, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
