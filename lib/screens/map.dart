import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(52.4064, 16.9252), // Centrum Poznania
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    try {
      final stores =
          await FirebaseFirestore.instance.collection('stores').get();
      print("📌 Znaleziono ${stores.docs.length} sklepów");

      setState(() {
        _markers.clear();
        for (var doc in stores.docs) {
          final data = doc.data();
          final locationString = data['location'] as String?;

          if (locationString != null) {
            final location = _parseLocation(locationString);

            if (location != null) {
              print(
                "✅ Dodaję znacznik: ${data['name']} (${location.latitude}, ${location.longitude})",
              );

              _markers.add(
                Marker(
                  markerId: MarkerId(doc.id),
                  position: location,
                  infoWindow: InfoWindow(
                    title: data['name'] ?? 'Sklep',
                    snippet: data['address'] ?? '',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet,
                  ),
                ),
              );
            } else {
              print("⚠️ Nieprawidłowy format lokalizacji: $locationString");
            }
          } else {
            print("⚠️ Brak pola 'location' w dokumencie ${doc.id}");
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Błąd przy pobieraniu sklepów: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  LatLng? _parseLocation(String locationString) {
    try {
      final parts = locationString.split(',');
      if (parts.length == 2) {
        final lat = double.parse(parts[0].trim());
        final lng = double.parse(parts[1].trim());
        return LatLng(lat, lng);
      }
      return null;
    } catch (e) {
      print("🚨 Błąd parsowania lokalizacji: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumpy Poznań'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStores,
            tooltip: 'Odśwież dane',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_markers.isNotEmpty) {
      //       mapController.animateCamera(
      //         CameraUpdate.newLatLngZoom(_markers.first.position, 14),
      //       );
      //     }
      //   },
      //   backgroundColor: Colors.purple,
      //   child: const Icon(Icons.location_searching, color: Colors.white),
      //   tooltip: 'Pokaż pierwszy sklep',
      // ),
    );
  }
}
