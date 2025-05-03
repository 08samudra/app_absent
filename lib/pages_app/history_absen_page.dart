import 'package:app_absent/providers/history_absent_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
    // Memanggil getHistoryAbsens dengan tanggal hari ini setelah build selesai
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAbsensiData();
    });
  }

  // Fungsi untuk mengambil data absensi berdasarkan tanggal yang dipilih
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
        title: const Text('Riwayat Absensi', style: TextStyle(fontSize: 18)),
        backgroundColor: Color(0xFF7AE2CF),
        elevation: 0,
      ),
      body: Consumer<RiwayatAbsenProvider>(
        builder: (context, riwayatAbsenProvider, child) {
          if (riwayatAbsenProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (riwayatAbsenProvider.errorMessage.isNotEmpty) {
            return Center(child: Text(riwayatAbsenProvider.errorMessage));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    // Ambil data setelah memilih tanggal
                    _fetchAbsensiData();
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF077A7D),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _selectedDay == null
                      ? 'Pilih tanggal untuk melihat riwayat'
                      : 'Riwayat absen tanggal: ${DateFormat('dd-MM-yyyy').format(_selectedDay!)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: riwayatAbsenProvider.historyAbsens.length,
                  itemBuilder: (context, index) {
                    final absen = riwayatAbsenProvider.historyAbsens[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              (absen['status'] == 'izin')
                                  ? Colors.orange
                                  : Colors.green,
                          child: Icon(
                            (absen['status'] == 'izin')
                                ? Icons.warning_amber_rounded
                                : Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'Check In: ${absen['check_in'] ?? '-'}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Check Out: ${absen['check_out'] ?? '-'}'),
                              Text('Status: ${absen['status'] ?? '-'}'),
                              if (absen['alasan_izin'] != null)
                                Text('Alasan Izin: ${absen['alasan_izin']}'),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Hapus Absen'),
                                    content: const Text(
                                      'Apakah kamu yakin ingin menghapus absen ini?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text(
                                          'Hapus',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              try {
                                await Provider.of<RiwayatAbsenProvider>(
                                  context,
                                  listen: false,
                                ).deleteAbsen(absen['id'].toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      textAlign: TextAlign.center,
                                      'Absen berhasil dihapus',
                                      style: TextStyle(
                                        color: Color(0xFF06202B),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFF7AE2CF),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      textAlign: TextAlign.center,
                                      'Gagal menghapus absen: $e',
                                      style: const TextStyle(
                                        color: Color(0xFF06202B),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFFF75A5A),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
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
}
