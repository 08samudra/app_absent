import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/absent_provider.dart';

class StatusDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<AbsenProvider>(context);

    return Column(
      children: [
        DropdownButton<String>(
          value: absenProvider.status,
          isExpanded: true,
          items:
              <String>['masuk', 'izin'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value[0].toUpperCase() + value.substring(1),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF06202B),
                    ),
                  ),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              absenProvider.setStatus(value);
            }
          },
        ),
        if (absenProvider.status == 'izin')
          TextField(
            decoration: const InputDecoration(
              labelText: 'Alasan Izin',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              absenProvider.setAlasanIzin(value);
            },
          ),
      ],
    );
  }
}
