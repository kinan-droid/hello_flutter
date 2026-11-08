import 'package:flutter/material.dart';

import '../models/krs_course.dart';
import '../widgets/krs_course_tile.dart';
import 'add_krs_screen.dart';
import 'course_detail_screen.dart';

class KrsListScreen extends StatefulWidget {
  const KrsListScreen({super.key});

  @override
  State<KrsListScreen> createState() => _KrsListScreenState();
}

class _KrsListScreenState extends State<KrsListScreen> {
  final List<KrsCourse> _courses =
      List<KrsCourse>.of(KrsCourse.getInitialCourses());

  static const int batasSksSemester = 24;
  static const int ambangPeringatanSks = 21;

  int get _totalSks {
    return _courses.fold(0, (total, course) => total + course.sks);
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  Future<void> _bukaDetail(KrsCourse course) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );
  }

  Future<void> _bukaFormTambah() async {
    final courseBaru = await Navigator.push<KrsCourse>(
      context,
      MaterialPageRoute<KrsCourse>(
        builder: (_) => const AddKrsScreen(),
      ),
    );

    if (!mounted || courseBaru == null) return;

    final kodeSudahAda = _courses.any(
      (course) =>
          course.code.toLowerCase() == courseBaru.code.toLowerCase(),
    );

    if (kodeSudahAda) {
      _tampilkanPesan('Kode mata kuliah sudah terdaftar.');
      return;
    }

    if (_totalSks + courseBaru.sks > batasSksSemester) {
      _tampilkanPesan('Total SKS tidak boleh melebihi 24 SKS.');
      return;
    }

    setState(() {
      _courses.add(courseBaru);
    });

    _tampilkanPesan('Mata kuliah berhasil ditambahkan.');
  }

  Future<void> _konfirmasiHapus(KrsCourse course) async {
    final dikonfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Mata Kuliah?'),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${course.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted || dikonfirmasi != true) return;

    setState(() {
      _courses.remove(course);
    });

    _tampilkanPesan('Mata kuliah berhasil dihapus.');
  }

  @override
  Widget build(BuildContext context) {
    final bool mendekatiBatas = _totalSks >= ambangPeringatanSks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar KRS Mahasiswa'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total SKS Semester',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$_totalSks / $batasSksSemester SKS',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (mendekatiBatas)
                          const Text(
                            'Anda mendekati batas maksimal SKS.',
                            style: TextStyle(color: Colors.orange),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _courses.isEmpty
                ? const Center(
                    child: Text('Belum ada mata kuliah yang dipilih.'),
                  )
                : ListView.builder(
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];

                      return KrsCourseTile(
                        course: course,
                        onTap: () => _bukaDetail(course),
                        onDelete: () => _konfirmasiHapus(course),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah KRS'),
      ),
    );
  }
}