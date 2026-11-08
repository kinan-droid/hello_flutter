import 'package:flutter/material.dart';
import '../models/krs_course.dart';
import 'ubah_sks_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  final KrsCourse course;

    @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late int _sksSaatIni;

  @override
  void initState() {
    super.initState();
    _sksSaatIni = widget.course.sks;
  }

  Future<void> _ubahSks() async {
    final hasil = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => const UbahSksScreen(),
      ),
    );

    if (hasil != null && mounted) {
      setState(() {
        _sksSaatIni = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(
                  Icons.menu_book,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.course.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _buildInfo(
              'Kode Mata Kuliah',
              widget.course.code,
            ),
            _buildInfo(
              'Dosen Pengampu',
              widget.course.lecturer,
            ),
            _buildInfo(
              'Jumlah SKS',
              '$_sksSaatIni SKS',
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Mata Kuliah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.course.description.isEmpty
                  ? 'Belum ada deskripsi mata kuliah.'
                  : widget.course.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, _sksSaatIni),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Daftar KRS'),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
               onPressed: _ubahSks,
               icon: const Icon(Icons.edit),
               label: const Text('Ubah Bobot SKS'),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}