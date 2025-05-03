import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/absent_provider.dart';

class CheckInOutButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<AbsenProvider>(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed:
                absenProvider.isLoading
                    ? null
                    : () => absenProvider.checkIn(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7AE2CF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                absenProvider.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Absen Masuk',
                      style: TextStyle(fontSize: 16, color: Color(0xFF06202B)),
                    ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed:
                absenProvider.isCheckOutLoading ||
                        !absenProvider.isCheckOutEnabled
                    ? null
                    : () => absenProvider.checkOutProcess(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF75A5A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                absenProvider.isCheckOutLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Absen Keluar',
                      style: TextStyle(fontSize: 16, color: Color(0xFF06202B)),
                    ),
          ),
        ),
      ],
    );
  }
}
