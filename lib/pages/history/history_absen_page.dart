import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:app_absent/providers/history_absent_provider.dart';
import 'package:app_absent/pages/history/widgets/calendar_widget.dart';
import 'package:app_absent/pages/history/widgets/absen_list_item.dart';
import 'package:table_calendar/table_calendar.dart';

class RiwayatAbsenPage extends StatefulWidget {
  @override
  _RiwayatAbsenPageState createState() => _RiwayatAbsenPageState();
}

class _RiwayatAbsenPageState extends State<RiwayatAbsenPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchAbsensiData());
  }

  void _fetchAbsensiData() {
    if (_selectedDay != null) {
      Provider.of<RiwayatAbsenProvider>(
        context,
        listen: false,
      ).getHistoryAbsens(
        startDate: DateFormat('yyyy-MM-dd').format(_selectedDay!),
        endDate: DateFormat('yyyy-MM-dd').format(_selectedDay!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Absensi',
          style: TextStyle(fontSize: 20, color: Color(0xFF06202B)),
        ),
        backgroundColor: Color(0xFF7AE2CF),
        elevation: 0,
      ),
      body: Consumer<RiwayatAbsenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (provider.errorMessage.isNotEmpty)
            return Center(child: Text(provider.errorMessage));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CalendarWidget(
                  selectedDay: _selectedDay!,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                    _fetchAbsensiData();
                  },
                  onFormatChanged:
                      (format) => setState(() => _calendarFormat = format),
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _selectedDay == null
                      ? 'Pilih tanggal untuk melihat riwayat'
                      : 'Riwayat absen tanggal: ${DateFormat('dd-MM-yyyy').format(_selectedDay!)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.historyAbsens.length,
                  itemBuilder: (context, index) {
                    final absen = provider.historyAbsens[index];
                    return AbsenListItem(
                      absen: absen,
                      onDelete:
                          () => _handleDelete(context, absen['id'].toString()),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Hapus Absen'),
            content: const Text('Apakah kamu yakin ingin menghapus absen ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await Provider.of<RiwayatAbsenProvider>(
          context,
          listen: false,
        ).deleteAbsen(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Absen berhasil dihapus',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Color(0xFF7AE2CF),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menghapus absen: $e',
              textAlign: TextAlign.center,
            ),
            backgroundColor: const Color(0xFFF75A5A),
          ),
        );
      }
    }
  }
}
