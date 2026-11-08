import 'tugas.dart';

abstract interface class RepositoriTugas {
  Future<List<Tugas>> muat();

  Future<Tugas> tambah({
    required String judul,
    required String mataKuliah,
    required int prioritas,
  });

  Future<Tugas> ubahStatus({required String id, required bool selesai});

  Future<void> hapus(String id);
}
