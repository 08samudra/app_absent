import 'package:app_absent/services/auth_services.dart';
import 'package:app_absent/services/login_model.dart';
import 'package:flutter/material.dart';
// import 'auth_services.dart'; // Import AuthService
// import 'login_model.dart'; // Import LoginResponse

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  final AuthService _authService = AuthService(); // Inisialisasi AuthService

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        LoginResponse response = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (response.data != null) {
          // Login berhasil
          // Navigasi ke halaman home
          Navigator.pushReplacementNamed(
            context,
            '/home',
          ); // Ganti '/home' dengan rute halaman home Anda
        } else {
          // Login gagal
          setState(() {
            _errorMessage = response.message;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email wajib diisi.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password wajib diisi.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading ? CircularProgressIndicator() : Text('Login'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                // Tombol untuk navigasi ke halaman registrasi
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/register',
                  ); // Navigasi ke halaman registrasi
                },
                child: Text('Belum punya akun? Registrasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
