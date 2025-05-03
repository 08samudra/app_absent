import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap extends StatelessWidget {
  final Future<LatLng?> locationFuture;
  final Function(GoogleMapController) onMapCreated;

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
      child: Container(
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
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data!,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: snapshot.data!,
                    ),
                  },
                  onMapCreated: onMapCreated,
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
