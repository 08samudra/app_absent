import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/absent_provider.dart';

void setupToastHandler(BuildContext context) {
  final absenProvider = Provider.of<AbsenProvider>(context, listen: false);

  absenProvider.addListener(() {
    if (absenProvider.message.isNotEmpty) {
      final isError =
          absenProvider.message.toLowerCase().contains('terjadi kesalahan') ||
          absenProvider.message.toLowerCase().contains('di luar radius') ||
          absenProvider.message.toLowerCase().contains('wajib diisi');

      showSnackBar(
        context,
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
        context,
        absenProvider.checkOutMessage,
        isError ? Colors.orange : const Color(0xFFF75A5A),
      );
      absenProvider.clearMessages();
    }
  });
}

void showSnackBar(BuildContext context, String message, Color bgColor) {
  ScaffoldMessenger.of(context).showSnackBar(
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
