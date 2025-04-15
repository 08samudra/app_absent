import 'package:app_absent/pages_app/absent_page.dart';
import 'package:app_absent/services/auth_services.dart';
import 'package:app_absent/services/user_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  Map<String, dynamic> _profileData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final token = await _userService.getToken();
      if (token == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final response = await _authService.getProfile();
      setState(() {
        _profileData = response['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Selamat Datang, ${_profileData['name']}!',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AbsenPage(),
                            ),
                          );
                        },
                        child: Text('Absen'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
