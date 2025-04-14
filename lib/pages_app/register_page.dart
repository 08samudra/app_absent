import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';
// import 'auth_services.dart'; // Import AuthService
// import 'login_model.dart'; // Import LoginResponse

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
  final AuthService _authService = AuthService(); // Inisialisasi AuthService

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
      appBar: AppBar(title: Text('Registrasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi.';
                  }
                  return null;
                },
              ),
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
                onPressed: _isLoading ? null : _register,
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
    );
  }
}
