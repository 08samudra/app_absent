import 'package:app_absent/providers/absen_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AbsentPage extends StatefulWidget {
  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsentPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AbsenProvider>(context, listen: false).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AbsenProvider>(
          builder: (context, absenProvider, child) {
            return Column(
              children: <Widget>[
                if (absenProvider.currentLocation != null)
                  Expanded(
                    flex: 2,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: absenProvider.currentLocation!,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('currentLocation'),
                          position: absenProvider.currentLocation!,
                        ),
                      },
                      onMapCreated: (GoogleMapController controller) {
                        absenProvider.setMapController(controller);
                      },
                    ),
                  ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: absenProvider.status,
                  items:
                      <String>['masuk', 'izin'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {
                    absenProvider.setStatus(value!);
                  },
                ),
                if (absenProvider.status == 'izin')
                  TextField(
                    decoration: InputDecoration(labelText: 'Alasan Izin'),
                    onChanged: (value) {
                      absenProvider.setAlasanIzin(value);
                    },
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      absenProvider.isLoading
                          ? null
                          : () => absenProvider.checkIn(context),
                  child: Text('Absen'),
                ),
                if (absenProvider.isLoading) CircularProgressIndicator(),
                if (absenProvider.message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(absenProvider.message),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
