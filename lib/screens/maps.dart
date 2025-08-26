import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';

class NearbyHospitalsPage extends StatefulWidget {
  @override
  _NearbyHospitalsPageState createState() => _NearbyHospitalsPageState();
}

class _NearbyHospitalsPageState extends State<NearbyHospitalsPage> {
  final MapController _mapController = MapController();
  LocationData? _currentLocation;
  List<Marker> _hospitalMarkers = [];
  Map<String, dynamic>? _selectedHospital;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _currentLocation = await location.getLocation();
    setState(() {});
  }

  Future<void> _findNearbyHospitals() async {
    if (_currentLocation == null) return;

    setState(() => _isLoading = true);
    final query = Uri.encodeComponent("hospital");
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=10&bounded=1&viewbox="
        "${_currentLocation!.longitude! - 0.05},${_currentLocation!.latitude! + 0.05},"
        "${_currentLocation!.longitude! + 0.05},${_currentLocation!.latitude! - 0.05}";

    try {
      Response response = await Dio().get(url);
      final hospitals = response.data;

      List<Marker> markers = [];
      for (var hospital in hospitals) {
        markers.add(Marker(
          point: LatLng(
            double.parse(hospital['lat']),
            double.parse(hospital['lon']),
          ),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showHospitalDetails({
              "name": hospital['display_name'],
              "latitude": double.parse(hospital['lat']),
              "longitude": double.parse(hospital['lon']),
            }),
            child: const Icon(
              Icons.local_hospital,
              color: Colors.red,
              size: 30,
            ),
          ),
        ));
      }

      setState(() {
        _hospitalMarkers = markers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching hospitals: $e");
    }
  }

  void _showHospitalDetails(Map<String, dynamic> hospital) {
    setState(() {
      _selectedHospital = hospital;
    });
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital['name'] ?? 'Unknown Hospital',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Latitude: ${hospital['latitude']}"),
              Text("Longitude: ${hospital['longitude']}"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Hospitals"),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _findNearbyHospitals,
            ),
        ],
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
  urlTemplate: "https://a.tile.openstreetmap.de/{z}/{x}/{y}.png",
),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    ..._hospitalMarkers,
                  ],
                ),
              ],
            ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
// import 'package:dio/dio.dart';

// class NearbyHospitalsPage extends StatefulWidget {
//   @override
//   _NearbyHospitalsPageState createState() => _NearbyHospitalsPageState();
// }

// class _NearbyHospitalsPageState extends State<NearbyHospitalsPage> {
//   final MapController _mapController = MapController();
//   LocationData? _currentLocation;
//   List<Marker> _hospitalMarkers = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Location location = Location();

//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }

//     _currentLocation = await location.getLocation();
//     setState(() {});
//   }

//   Future<void> _findNearbyHospitals() async {
//     if (_currentLocation == null) return;

//     setState(() => _isLoading = true);
//     final query = Uri.encodeComponent("hospital");
//     final url =
//         "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=10&bounded=1&viewbox="
//         "${_currentLocation!.longitude! - 0.05},${_currentLocation!.latitude! + 0.05},"
//         "${_currentLocation!.longitude! + 0.05},${_currentLocation!.latitude! - 0.05}";

//     try {
//       Response response = await Dio().get(url);
//       final hospitals = response.data;

//       List<Marker> markers = [];
//       for (var hospital in hospitals) {
//         markers.add(Marker(
//           point: LatLng(
//             double.parse(hospital['lat']),
//             double.parse(hospital['lon']),
//           ),
//           width: 40,
//           height: 40,
//           child: const Icon(
//             Icons.local_hospital,
//             color: Colors.red,
//             size: 100,
//           ),
//         ));
//       }

//       setState(() {
//         _hospitalMarkers = markers;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       print("Error fetching hospitals: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Hospitals"),
//         actions: [
//           if (!_isLoading)
//             IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: _findNearbyHospitals,
//             ),
//         ],
//       ),
//       body: _currentLocation == null
//           ? const Center(child: CircularProgressIndicator())
//           : FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 initialCenter: LatLng(
//                   _currentLocation!.latitude!,
//                   _currentLocation!.longitude!,
//                 ),
//                 initialZoom: 15.0,
//               ),
//               children: [
//                 TileLayer(
//   urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
// ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: LatLng(
//                         _currentLocation!.latitude!,
//                         _currentLocation!.longitude!,
//                       ),
//                       width: 40,
//                       height: 40,
//                       child: const Icon(
//                         Icons.my_location,
//                         color: Colors.blue,
//                         size: 30,
//                       ),
//                     ),
//                     ..._hospitalMarkers,
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }
// }
