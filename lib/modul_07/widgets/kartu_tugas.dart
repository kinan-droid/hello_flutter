import 'package:flutter/material.dart';

import '../domain/tugas.dart';

class KartuTugas extends StatelessWidget {
  const KartuTugas({
    super.key,
    required this.tugas,
    required this.onUbahStatus,
    required this.onHapus,
  });

  final Tugas tugas;
  final ValueChanged<bool> onUbahStatus;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: tugas.selesai,
          onChanged: (nilai) {
            if (nilai != null) {
              onUbahStatus(nilai);
            }
          },
        ),
        title: Text(
          tugas.judul,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: tugas.selesai
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tugas.mataKuliah),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.flag, size: 14),
                const SizedBox(width: 4),
                Text('Prioritas ${tugas.prioritas}'),
                const SizedBox(width: 12),
                Text(tugas.selesai ? 'Selesai' : 'Belum selesai'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: 'Hapus tugas',
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onHapus,
        ),
      ),
    );
  }
}
