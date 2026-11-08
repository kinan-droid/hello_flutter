import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../modul_03/models/krs_course.dart';
import '../krs_provider.dart';

class KrsListScreen extends ConsumerWidget {
  const KrsListScreen({super.key});

  Future<void> _konfirmasiHapus(
    BuildContext context,
    WidgetRef ref,
    KrsCourse course,
  ) async {
    final hasil = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Mata Kuliah'),
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

    if (hasil == true) {
      ref.read(krsProvider.notifier).hapusMataKuliah(course.code);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(krsProvider);
    final totalSks = ref.watch(totalSksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KRS - Fase B'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.school,
                  color: Colors.blue,
                  size: 32,
                ),
                title: const Text('Total SKS'),
                subtitle: Text('$totalSks dari 24 SKS'),
                trailing: Text(
                  '$totalSks/24',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: courses.isEmpty
                  ? const Center(
                      child: Text('Belum ada mata kuliah.'),
                    )
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];

                        return Card(
                          child: ListTile(
                            title: Text(course.name),
                            subtitle: Text(
                              '${course.code} • ${course.lecturer}\n'
                              '${course.sks} SKS',
                            ),
                            isThreeLine: true,
                            onTap: () {
                              context.push(
                                '/modul-03/detail/${course.code}',
                              );
                            },
                            trailing: IconButton(
                              tooltip: 'Hapus mata kuliah',
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _konfirmasiHapus(
                                  context,
                                  ref,
                                  course,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/modul-03/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah KRS'),
      ),
    );
  }
}