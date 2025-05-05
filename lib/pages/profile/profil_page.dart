import 'package:app_absent/pages/profile/widgets/profile_edit_button.dart';
import 'package:app_absent/pages/profile/widgets/profile_header.dart';
import 'package:app_absent/pages/profile/widgets/profile_info_card.dart';
import 'package:app_absent/providers/history_absent_provider.dart';
import 'package:app_absent/providers/profil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
      Provider.of<RiwayatAbsenProvider>(
        context,
        listen: false,
      ).getHistoryAbsens();
    });
  }

  Future<void> _reloadProfile() async {
    await Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(fontSize: 20, color: Color(0xFF06202B)),
        ),
        backgroundColor: Color(0xFF7AE2CF),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${profileProvider.errorMessage}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (profileProvider.profileData.isEmpty) {
            return const Center(child: Text('Data profil tidak tersedia.'));
          }

          final profile = profileProvider.profileData;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ProfileHeader(profile: profile),
                const SizedBox(height: 30),
                const ProfileInfoCard(),
                const SizedBox(height: 30),
                ProfileEditButton(onUpdated: _reloadProfile),
              ],
            ),
          );
        },
      ),
    );
  }
}
