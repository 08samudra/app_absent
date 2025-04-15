import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  final AuthService _authService = AuthService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final responseData = await _authService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );

        if (responseData['message'] == 'Registrasi berhasil') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Registrasi berhasil!')));
          Navigator.pop(context); // Kembali ke halaman login
        } else {
          setState(() {
            if (responseData['errors'] != null) {
              _errorMessage = responseData['errors'].values.join('\n');
            } else {
              _errorMessage = responseData['message'];
            }
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
                          'Registrasi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 105, 200, 212),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama wajib diisi.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
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
                          onPressed: _isLoading ? null : _register,
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
                                  : Text('Registrasi'),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
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
