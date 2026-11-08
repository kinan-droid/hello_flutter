import 'package:flutter/material.dart';
import '../models/announcement.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;
  final int jumlahKategori;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
    required this.jumlahKategori,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
        backgroundColor: warna.primary,
        foregroundColor: warna.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                announcement.category,
                style: TextStyle(
                  color: warna.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(announcement.author)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 6),
                Text(announcement.date),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.visibility_outlined, size: 18),
                const SizedBox(width: 6),
                Text('${announcement.readCount} kali dibaca'),
              ],
            ),
            const SizedBox(height: 24),
            Card(
  color: warna.secondaryContainer,
  child: ListTile(
    leading: const Icon(Icons.category_outlined),
    title: Text(
      'Jumlah pengumuman kategori ${announcement.category}',
    ),
    subtitle: Text(
      '$jumlahKategori pengumuman dalam kategori ini',
    ),
  ),
),
const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Isi Pengumuman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              announcement.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}