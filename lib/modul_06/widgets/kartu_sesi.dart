import 'package:flutter/material.dart';
import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final VoidCallback onKeluar;
  final bool sedangKeluar;
  final DateTime sekarang;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.onKeluar,
    this.sedangKeluar = false,
    required this.sekarang,
  });

  static String samarkanToken(String token) {
    if (token.isEmpty) return '-';
    if (token.length <= 6) return '${token.substring(0, 2)}••••';

    return '${token.substring(0, 6)}••••••••••••';
  }

  static String formatWaktu(String iso) {
    final DateTime? waktu = DateTime.tryParse(iso);
    if (waktu == null) return '-';

    const List<String> bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    return '${waktu.day} ${bulan[waktu.month - 1]} ${waktu.year}, '
        '${waktu.hour.toString().padLeft(2, '0')}:'
        '${waktu.minute.toString().padLeft(2, '0')}';
  }

  static String formatSisa(Duration sisa) {
    if (sisa <= Duration.zero) return 'Kedaluwarsa';

    final int jam = sisa.inHours;
    final int menit = sisa.inMinutes.remainder(60);
    final int detik = sisa.inSeconds.remainder(60);

    return '${jam}j ${menit}m ${detik}d';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;
    final Duration sisa = sesi.sisaWaktu(sekarang);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: warna.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: warna.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sesi.nama,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(sesi.email),
                    ],
                  ),
                ),
                Chip(
                  label: Text(SesiPengguna.labelPeran(sesi.peran)),
                ),
              ],
            ),
            const Divider(height: 28),
            _barisInfo('Waktu masuk', formatWaktu(sesi.masukPada)),
            _barisInfo('Sisa sesi', formatSisa(sisa)),
            _barisInfo('Token', samarkanToken(sesi.token)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: sedangKeluar ? null : onKeluar,
                icon: sedangKeluar
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.logout),
                label: Text(
                  sedangKeluar ? 'Sedang keluar...' : 'Keluar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barisInfo(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              judul,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(isi)),
        ],
      ),
    );
  }
}