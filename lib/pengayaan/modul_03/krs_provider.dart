import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modul_03/models/krs_course.dart';

// Provider untuk mengelola daftar mata kuliah KRS
class KrsNotifier extends Notifier<List<KrsCourse>> {
  static const int batasMaksimalSks = 24;

  @override
  List<KrsCourse> build() {
    return KrsCourse.getInitialCourses();
  }

  // Menambahkan mata kuliah baru
  String? tambahMataKuliah(KrsCourse course) {
    final kodeSudahAda = state.any(
      (item) => item.code.toLowerCase() == course.code.toLowerCase(),
    );

    if (kodeSudahAda) {
      return 'Kode mata kuliah sudah terdaftar.';
    }

    final totalSetelahDitambah = totalSks + course.sks;

    if (totalSetelahDitambah > batasMaksimalSks) {
      return 'Total SKS tidak boleh melebihi 24.';
    }

    state = [...state, course];

    return null;
  }

  // Menghapus mata kuliah berdasarkan kode
  void hapusMataKuliah(String code) {
    state = state.where((course) => course.code != code).toList();
  }

  // Menghitung total SKS
  int get totalSks {
    return state.fold(
      0,
      (total, course) => total + course.sks,
    );
  }
}

// Provider utama daftar KRS
final krsProvider =
    NotifierProvider<KrsNotifier, List<KrsCourse>>(
  KrsNotifier.new,
);

// Provider untuk menghitung total SKS secara otomatis
final totalSksProvider = Provider<int>((ref) {
  final courses = ref.watch(krsProvider);

  return courses.fold(
    0,
    (total, course) => total + course.sks,
  );
});