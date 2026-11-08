import '../domain/tugas.dart';

enum StatusMuat { awal, memuat, siap, gagal }

class StateDaftarTugas {
  const StateDaftarTugas({
    this.status = StatusMuat.awal,
    this.daftar = const [],
    this.pesanGagal,
  });

  final StatusMuat status;
  final List<Tugas> daftar;
  final String? pesanGagal;

  bool get kosong => status == StatusMuat.siap && daftar.isEmpty;

  int get jumlahBelumSelesai => daftar.where((tugas) => !tugas.selesai).length;
}
