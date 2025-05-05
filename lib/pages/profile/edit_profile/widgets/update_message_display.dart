import 'package:flutter/material.dart';

class UpdateMessageDisplay extends StatelessWidget {
  final String message;

  const UpdateMessageDisplay({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return SizedBox.shrink();

    final bool isSuccess = message.contains('berhasil');

    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }
}
