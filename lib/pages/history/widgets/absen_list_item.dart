import 'package:flutter/material.dart';

class AbsenListItem extends StatelessWidget {
  final Map<String, dynamic> absen;
  final VoidCallback onDelete;

  const AbsenListItem({required this.absen, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              absen['status'] == 'izin' ? Colors.orange : Colors.green,
          child: Icon(
            absen['status'] == 'izin'
                ? Icons.warning_amber_rounded
                : Icons.check,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Check In: ${absen['check_in'] ?? '-'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check Out: ${absen['check_out'] ?? '-'}'),
            Text('Status: ${absen['status'] ?? '-'}'),
            if (absen['alasan_izin'] != null)
              Text('Alasan Izin: ${absen['alasan_izin']}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
