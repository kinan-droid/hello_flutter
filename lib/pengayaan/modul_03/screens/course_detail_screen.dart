import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modul_03/models/krs_course.dart';
import '../krs_provider.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({
    super.key,
    required this.courseCode,
  });

  final String courseCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(krsProvider);

    KrsCourse? course;

    for (final item in courses) {
      if (item.code.toLowerCase() == courseCode.toLowerCase()) {
        course = item;
        break;
      }
    }

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Mata Kuliah')),
        body: const Center(
          child: Text('Mata kuliah tidak ditemukan.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.menu_book,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              course.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _detailItem('Kode Mata Kuliah', course.code),
            _detailItem('Nama Dosen', course.lecturer),
            _detailItem('Jumlah SKS', '${course.sks} SKS'),
            _detailItem(
              'Deskripsi',
              course.description.isEmpty
                  ? 'Tidak ada deskripsi.'
                  : course.description,
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}