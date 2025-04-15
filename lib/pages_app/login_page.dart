import 'package:app_absent/services/auth_services.dart';
import 'package:app_absent/services/login_model.dart';
import 'package:flutter/material.dart';

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
  final AuthService _authService = AuthService();

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
          Navigator.pushReplacementNamed(context, '/home');
        } else {
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
      body: Stack(
        children: <Widget>[
          // Background Image
          Image.asset(
            'assets/images/bg_screen3.jpg', // Ganti dengan path gambar Anda
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 105, 200, 212),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email wajib diisi.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password wajib diisi.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : Text('Login'),
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Belum punya akun? Registrasi',
                            style: TextStyle(
                              color: Colors.green,
                            ), // Warna teks registrasi
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
