import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap extends StatelessWidget {
  final Future<LatLng?> locationFuture;
  final Function(GoogleMapController) onMapCreated;

  static const LatLng kantorLocation = LatLng(-6.210881, 106.812942);
  static const double allowedRadius = 100;

  const LocationMap({
    super.key,
    required this.locationFuture,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FutureBuilder<LatLng?>(
            future: locationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Gagal mendapatkan lokasi: ${snapshot.error}'),
                );
              } else if (snapshot.data != null) {
                final userLocation = snapshot.data!;
                final bool isSameLocation =
                    (userLocation.latitude - kantorLocation.latitude).abs() <
                        0.00005 &&
                    (userLocation.longitude - kantorLocation.longitude).abs() <
                        0.00005;

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: userLocation,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('kantor'),
                      position: kantorLocation,
                      infoWindow: const InfoWindow(title: 'Lokasi Kantor'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                    if (!isSameLocation)
                      Marker(
                        markerId: const MarkerId('user'),
                        position: userLocation,
                        infoWindow: const InfoWindow(title: 'Lokasi Anda'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                      ),
                  },

                  circles: {
                    Circle(
                      circleId: const CircleId('absenRadius'),
                      center: kantorLocation,
                      radius: allowedRadius,
                      fillColor: Colors.blue.withOpacity(0.2),
                      strokeColor: Colors.blue,
                      strokeWidth: 2,
                    ),
                  },
                  onMapCreated: onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                );
              } else {
                return const Center(child: Text('Lokasi belum tersedia.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
