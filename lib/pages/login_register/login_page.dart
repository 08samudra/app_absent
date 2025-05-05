import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_absent/providers/login_provider.dart';
import 'package:app_absent/pages/login_register/widgets/auth_background.dart';
import 'package:app_absent/pages/login_register/widgets/auth_form_field.dart';
import 'package:app_absent/pages/login_register/widgets/auth_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
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
              child: Consumer<LoginProvider>(
                builder:
                    (context, loginProvider, _) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AuthHeader(title: 'Hallo, Selamat Datang'),
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
                                loginProvider.isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        loginProvider.login(
                                          context,
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
                                loginProvider.isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                    : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (loginProvider.errorMessage.isNotEmpty)
                          Text(
                            loginProvider.errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            'Belum punya akun? Registrasi di sini',
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
