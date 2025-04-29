import 'package:app_absent/providers/absen_provider.dart';
import 'package:app_absent/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<LatLng?>? _locationFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchProfile(context);
      _locationFuture =
          Provider.of<AbsenProvider>(
            context,
            listen: false,
          ).getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<AbsenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Absensi'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Absensi App',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Absen'),
              onTap: () {
                Navigator.pushNamed(context, '/history_absen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await Provider.of<HomeProvider>(
                  context,
                  listen: false,
                ).removeToken();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (homeProvider.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${homeProvider.errorMessage}'));
          }

          if (homeProvider.profileData.isEmpty) {
            return const Center(child: Text('Data profil tidak tersedia.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Halo, ${homeProvider.profileData['name']}!',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // TANGGAL & JAM DIGITAL
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: StreamBuilder<DateTime>(
                      stream: Stream.periodic(
                        const Duration(seconds: 1),
                        (_) => DateTime.now(),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const CircularProgressIndicator();

                        final now = snapshot.data!;
                        final days = [
                          'Senin',
                          'Selasa',
                          'Rabu',
                          'Kamis',
                          'Jumat',
                          'Sabtu',
                          'Minggu',
                        ];
                        final months = [
                          'Januari',
                          'Februari',
                          'Maret',
                          'April',
                          'Mei',
                          'Juni',
                          'Juli',
                          'Agustus',
                          'September',
                          'Oktober',
                          'November',
                          'Desember',
                        ];

                        final dayName = days[now.weekday - 1];
                        final monthName = months[now.month - 1];
                        final dateStr =
                            '$dayName, ${now.day} $monthName ${now.year}';
                        final timeStr =
                            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              '|',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white54,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FutureBuilder<LatLng?>(
                        future: _locationFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Gagal mendapatkan lokasi: ${snapshot.error}',
                              ),
                            );
                          } else if (snapshot.data != null) {
                            return GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: snapshot.data!,
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('currentLocation'),
                                  position: snapshot.data!,
                                ),
                              },
                              onMapCreated: (controller) {
                                absenProvider.setMapController(controller);
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('Lokasi belum tersedia.'),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Status Absensi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: absenProvider.status,
                  isExpanded: true,
                  items:
                      <String>['masuk', 'izin'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      absenProvider.setStatus(value);
                    }
                  },
                ),
                if (absenProvider.status == 'izin')
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Alasan Izin',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      absenProvider.setAlasanIzin(value);
                    },
                  ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            absenProvider.isLoading
                                ? null
                                : () => absenProvider.checkIn(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            absenProvider.isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Absen Masuk',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            absenProvider.isCheckOutLoading ||
                                    !absenProvider.isCheckOutEnabled
                                ? null
                                : () => absenProvider.checkOutProcess(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            absenProvider.isCheckOutLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Absen Keluar',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (absenProvider.message.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      absenProvider.message,
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ),
                if (absenProvider.checkOutMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      absenProvider.checkOutMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
