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

  String _filterSks = 'Semua';
  String _urutan = 'Kode A-Z';

  int get _totalSks {
    return _courses.fold(0, (total, course) => total + course.sks);
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

Future<void> _bukaDetail(KrsCourse course) async {
  final hasil = await Navigator.push<int>(
    context,
    MaterialPageRoute(
      builder: (context) => CourseDetailScreen(course: course),
    ),
  );

  if (hasil != null && mounted) {
    setState(() {
      final index = _courses.indexWhere(
        (item) => item.code == course.code,
      );

      if (index != -1) {
        _courses[index] = KrsCourse(
          code: course.code,
          name: course.name,
          lecturer: course.lecturer,
          sks: hasil,
          description: course.description,
        );
      }
    });
  }
}

  Future<void> _bukaFormTambah() async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    
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

    final daftarTampil = _courses.where((course) {
  if (_filterSks == '1-2 SKS') {
    return course.sks <= 2;
  } else if (_filterSks == '3-4 SKS') {
    return course.sks >= 3 && course.sks <= 4;
  } else if (_filterSks == '5-6 SKS') {
    return course.sks >= 5 && course.sks <= 6;
  }
  return true;
}).toList();

if (_urutan == 'Kode A-Z') {
  daftarTampil.sort((a, b) => a.code.compareTo(b.code));
} else if (_urutan == 'Kode Z-A') {
  daftarTampil.sort((a, b) => b.code.compareTo(a.code));
} else if (_urutan == 'SKS Terbesar') {
  daftarTampil.sort((a, b) => b.sks.compareTo(a.sks));
} else if (_urutan == 'SKS Terkecil') {
  daftarTampil.sort((a, b) => a.sks.compareTo(b.sks));
}
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

          Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    children: [
      DropdownButtonFormField<String>(
        initialValue: _filterSks,
        decoration: const InputDecoration(
          labelText: 'Filter Jumlah SKS',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Semua', child: Text('Semua SKS')),
          DropdownMenuItem(value: '1-2 SKS', child: Text('1-2 SKS')),
          DropdownMenuItem(value: '3-4 SKS', child: Text('3-4 SKS')),
          DropdownMenuItem(value: '5-6 SKS', child: Text('5-6 SKS')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _filterSks = value;
            });
          }
        },
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        initialValue: _urutan,
        decoration: const InputDecoration(
          labelText: 'Urutkan Mata Kuliah',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Kode A-Z', child: Text('Kode A-Z')),
          DropdownMenuItem(value: 'Kode Z-A', child: Text('Kode Z-A')),
          DropdownMenuItem(value: 'SKS Terbesar', child: Text('SKS Terbesar')),
          DropdownMenuItem(value: 'SKS Terkecil', child: Text('SKS Terkecil')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _urutan = value;
            });
          }
        },
      ),
      const SizedBox(height: 12),
    ],
  ),
),

          Expanded(
            child: daftarTampil.isEmpty
                ? const Center(
                    child: Text('Belum ada mata kuliah yang dipilih.'),
                  )
                : ListView.builder(
                    itemCount: daftarTampil.length,
                    itemBuilder: (context, index) {
                      final course = daftarTampil[index];

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