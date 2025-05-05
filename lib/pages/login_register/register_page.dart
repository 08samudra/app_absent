import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_absent/providers/register_provider.dart';
import 'package:app_absent/pages/login_register/widgets/auth_background.dart';
import 'package:app_absent/pages/login_register/widgets/auth_form_field.dart';
import 'package:app_absent/pages/login_register/widgets/auth_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white.withOpacity(0.95),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Consumer<RegisterProvider>(
                builder:
                    (context, registerProvider, _) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AuthHeader(title: 'Registrasi Akun'),
                        AuthFormField(
                          controller: _nameController,
                          label: 'Nama Lengkap',
                          icon: Icons.person_outline,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Nama wajib diisi.'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        AuthFormField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Email wajib diisi.'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        AuthFormField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Password wajib diisi.'
                                      : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                registerProvider.isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        registerProvider.register(
                                          context,
                                          _nameController.text.trim(),
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child:
                                registerProvider.isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                    : const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Sudah punya akun? Login di sini',
                            style: TextStyle(
                              color: Color.fromARGB(255, 212, 132, 12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
