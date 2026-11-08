import '../domain/kegagalan.dart';
import '../domain/repositori_tugas.dart';
import '../domain/tugas.dart';
import 'sumber_tugas_memori.dart';

class RepositoriTugasMemori implements RepositoriTugas {
  RepositoriTugasMemori(this.sumber, {DateTime Function()? jam})
    : _jam = jam ?? DateTime.now;

  final SumberTugasMemori sumber;
  final DateTime Function() _jam;

  Tugas _dariBaris(Map<String, Object?> baris) {
    return Tugas(
      id: baris['id'] as String,
      judul: baris['judul'] as String,
      mataKuliah: baris['mata_kuliah'] as String,
      selesai: baris['selesai'] == 1,
      dibuatPada: baris['dibuat_pada'] as String,
      prioritas: (baris['prioritas'] as int?) ?? 2,
    );
  }

  Map<String, Object?> _keBaris(Tugas tugas) {
    return {
      'judul': tugas.judul,
      'mata_kuliah': tugas.mataKuliah,
      'selesai': tugas.selesai ? 1 : 0,
      'dibuat_pada': tugas.dibuatPada,
      'prioritas': tugas.prioritas.clamp(1, 3),
    };
  }

  Kegagalan _terjemahkan(Object error) {
    if (error.toString().contains('Tugas tidak ditemukan')) {
      return const TugasTidakDitemukan();
    }

    return const SumberDataGagal();
  }

  @override
  Future<List<Tugas>> muat() async {
    try {
      final baris = await sumber.bacaSemua();
      return baris.map(_dariBaris).toList();
    } catch (error) {
      throw _terjemahkan(error);
    }
  }

  @override
  Future<Tugas> tambah({
    required String judul,
    required String mataKuliah,
    required int prioritas,
  }) async {
    if (judul.trim().isEmpty) {
      throw const JudulKosong();
    }

    try {
      final tugas = Tugas(
        id: '',
        judul: judul.trim(),
        mataKuliah: mataKuliah.trim(),
        selesai: false,
        dibuatPada: _jam().toIso8601String(),
        prioritas: prioritas.clamp(1, 3),
      );

      final hasil = await sumber.tambah(_keBaris(tugas));
      return _dariBaris(hasil);
    } catch (error) {
      if (error is Kegagalan) rethrow;
      throw _terjemahkan(error);
    }
  }

  @override
  Future<Tugas> ubahStatus({required String id, required bool selesai}) async {
    try {
      final hasil = await sumber.ubahStatus(id, selesai);
      return _dariBaris(hasil);
    } catch (error) {
      throw _terjemahkan(error);
    }
  }

  @override
  Future<void> hapus(String id) async {
    try {
      await sumber.hapus(id);
    } catch (error) {
      throw _terjemahkan(error);
    }
  }
}
