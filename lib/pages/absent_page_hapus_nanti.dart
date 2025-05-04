// import 'package:app_absent/providers/absen_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// class AbsentPage extends StatefulWidget {
//   @override
//   _AbsenPageState createState() => _AbsenPageState();
// }

// class _AbsenPageState extends State<AbsentPage> {
//   Future<LatLng?>? _locationFuture;

//   @override
//   void initState() {
//     super.initState();
//     _locationFuture =
//         Provider.of<AbsenProvider>(context, listen: false).getCurrentLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Absen')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Consumer<AbsenProvider>(
//           builder: (context, absenProvider, child) {
//             return Column(
//               children: <Widget>[
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey, width: 1.0),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: FutureBuilder<LatLng?>(
//                       future: _locationFuture,
//                       builder: (
//                         BuildContext context,
//                         AsyncSnapshot<LatLng?> snapshot,
//                       ) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else if (snapshot.hasError) {
//                           return Center(
//                             child: Text(
//                               'Gagal mendapatkan lokasi: ${snapshot.error}',
//                             ),
//                           );
//                         } else if (snapshot.data != null) {
//                           return GoogleMap(
//                             initialCameraPosition: CameraPosition(
//                               target: snapshot.data!,
//                               zoom: 15,
//                             ),
//                             markers: {
//                               Marker(
//                                 markerId: MarkerId('currentLocation'),
//                                 position: snapshot.data!,
//                               ),
//                             },
//                             onMapCreated: (GoogleMapController controller) {
//                               absenProvider.setMapController(controller);
//                             },
//                           );
//                         } else {
//                           return Center(child: Text('Lokasi belum tersedia.'));
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButton<String>(
//                   value: absenProvider.status,
//                   items:
//                       <String>['masuk', 'izin'].map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                   onChanged: (value) {
//                     absenProvider.setStatus(value!);
//                   },
//                 ),
//                 if (absenProvider.status == 'izin')
//                   TextField(
//                     decoration: InputDecoration(labelText: 'Alasan Izin'),
//                     onChanged: (value) {
//                       absenProvider.setAlasanIzin(value);
//                     },
//                   ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed:
//                       absenProvider.isLoading
//                           ? null
//                           : () => absenProvider.checkIn(context),
//                   child: Text('Absen Masuk'),
//                 ),
//                 SizedBox(height: 8),
//                 // Tombol Check Out
//                 ElevatedButton(
//                   onPressed:
//                       absenProvider.isCheckOutLoading ||
//                               !absenProvider.isCheckOutEnabled
//                           ? null
//                           : () => absenProvider.checkOutProcess(context),
//                   child:
//                       absenProvider.isCheckOutLoading
//                           ? CircularProgressIndicator()
//                           : Text('Absen Keluar'),
//                 ),
//                 if (absenProvider.isLoading) CircularProgressIndicator(),
//                 if (absenProvider.message.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(absenProvider.message),
//                   ),
//                 if (absenProvider.checkOutMessage.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(absenProvider.checkOutMessage),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
