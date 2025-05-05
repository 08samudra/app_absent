import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/absent_provider.dart';
import '../../../main.dart'; // pastikan import ini untuk scaffoldMessengerKey

void setupToastHandler(BuildContext context) {
  final absenProvider = Provider.of<AbsenProvider>(context, listen: false);

  absenProvider.addListener(() {
    if (absenProvider.message.isNotEmpty) {
      final isError =
          absenProvider.message.toLowerCase().contains('terjadi kesalahan') ||
          absenProvider.message.toLowerCase().contains('di luar radius') ||
          absenProvider.message.toLowerCase().contains('wajib diisi');

      showSnackBar(
        absenProvider.message,
        isError ? Colors.orange : const Color(0xFF7AE2CF),
      );
      absenProvider.clearMessages();
    }

    if (absenProvider.checkOutMessage.isNotEmpty) {
      final isError = absenProvider.checkOutMessage.toLowerCase().contains(
        'terjadi kesalahan',
      );

      showSnackBar(
        absenProvider.checkOutMessage,
        isError ? Colors.orange : const Color(0xFFF75A5A),
      );
      absenProvider.clearMessages();
    }
  });
}

void showSnackBar(String message, Color bgColor) {
  final messenger = scaffoldMessengerKey.currentState;
  if (messenger != null) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF06202B)),
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
