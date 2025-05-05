import 'package:flutter/material.dart';

class DigitalClock extends StatelessWidget {
  const DigitalClock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF06202B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: StreamBuilder<DateTime>(
        stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final now = snapshot.data!;
          final days = [
            'Senin',
            'Selasa',
            'Rabu',
            'Kamis',
            'Jumat',
            'Sabtu',
            'Minggu',
          ];
          final months = [
            'Januari',
            'Februari',
            'Maret',
            'April',
            'Mei',
            'Juni',
            'Juli',
            'Agustus',
            'September',
            'Oktober',
            'November',
            'Desember',
          ];

          final dayName = days[now.weekday - 1];
          final monthName = months[now.month - 1];
          final dateStr = '$dayName, ${now.day} $monthName ${now.year}';
          final timeStr =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dateStr,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 16),
              Text('|', style: TextStyle(fontSize: 18, color: Colors.white54)),
              SizedBox(width: 16),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
