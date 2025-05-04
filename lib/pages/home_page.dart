import 'package:app_absent/providers/absent_provider.dart';
import 'package:app_absent/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:app_absent/components/digital_clock_home.dart';
import 'package:app_absent/components/location_map_home.dart';
import 'package:app_absent/components/check_in_out_buttons_home.dart';
import 'package:app_absent/components/status_dropdown_home.dart';
import 'package:app_absent/components/toast_handler_home.dart';
import 'package:app_absent/components/user_card_home.dart';
import 'package:app_absent/components/drawer_home.dart';

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
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      final absenProvider = Provider.of<AbsenProvider>(context, listen: false);

      homeProvider.fetchProfile(context);
      _locationFuture = absenProvider.getCurrentLocation();
      setupToastHandler(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Halaman Absensi',
          style: TextStyle(color: Color(0xFF06202B), fontSize: 20),
        ),
        backgroundColor: const Color(0xFF7AE2CF),
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body:
          homeProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : homeProvider.errorMessage.isNotEmpty
              ? Center(child: Text('Error: ${homeProvider.errorMessage}'))
              : homeProvider.profileData.isEmpty
              ? const Center(child: Text('Data profil tidak tersedia.'))
              : _locationFuture == null
              ? const Center(child: CircularProgressIndicator()) // ⬅️ Tambahan
              : buildContent(context, homeProvider),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: const Color(0xFF7AE2CF),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Image.asset(
                      'assets/images/logo_ppkd.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Absensi App',
                    style: TextStyle(
                      color: Color(0xFF06202B),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                DrawerCardItem(
                  icon: Icons.person,
                  text: 'Profil',
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                DrawerCardItem(
                  icon: Icons.history,
                  text: 'Riwayat Absensi',
                  onTap: () => Navigator.pushNamed(context, '/history_absen'),
                ),
                DrawerCardItem(
                  icon: Icons.logout,
                  text: 'Logout',
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
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context, HomeProvider homeProvider) {
    final absenProvider = Provider.of<AbsenProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserGreetingCard(name: homeProvider.profileData['name']),
          const SizedBox(height: 12),
          const Center(child: DigitalClock()),
          const SizedBox(height: 20),
          LocationMap(
            locationFuture: _locationFuture!,
            onMapCreated: absenProvider.setMapController,
          ),

          const SizedBox(height: 20),
          const Text(
            'Status Absensi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF06202B),
            ),
          ),
          const SizedBox(height: 10),
          StatusDropdown(),
          const SizedBox(height: 20),
          CheckInOutButtons(),
        ],
      ),
    );
  }
}
