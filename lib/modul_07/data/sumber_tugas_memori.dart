class SumberTugasMemori {
  SumberTugasMemori({this.gagalSaatMuat = false, this.gagalSaatTulis = false}) {
    _baris = _dataContoh
        .map((item) => Map<String, Object?>.from(item))
        .toList();
  }

  bool gagalSaatMuat;
  bool gagalSaatTulis;

  late List<Map<String, Object?>> _baris;

  static const List<Map<String, Object?>> _dataContoh = [
    {
      'id': 'T001',
      'judul': 'Mempelajari MVVM',
      'mata_kuliah': 'Pemrograman Flutter',
      'selesai': 0,
      'dibuat_pada': '2026-11-08T08:00:00.000',
      'prioritas': 1,
    },
    {
      'id': 'T002',
      'judul': 'Membuat laporan praktikum',
      'mata_kuliah': 'Arsitektur Perangkat Lunak',
      'selesai': 0,
      'dibuat_pada': '2026-11-08T09:00:00.000',
      'prioritas': 2,
    },
    {
      'id': 'T003',
      'judul': 'Mempelajari Repository Pattern',
      'mata_kuliah': 'Pemrograman Flutter',
      'selesai': 1,
      'dibuat_pada': '2026-11-08T10:00:00.000',
      'prioritas': 3,
    },
  ];

  Future<List<Map<String, Object?>>> bacaSemua() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (gagalSaatMuat) {
      throw Exception('Gagal memuat data tugas.');
    }

    return _baris.reversed
        .map((item) => Map<String, Object?>.from(item))
        .toList();
  }

  Future<Map<String, Object?>> tambah(Map<String, Object?> data) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (gagalSaatTulis) {
      throw Exception('Gagal menyimpan tugas.');
    }

    final id = 'T${DateTime.now().microsecondsSinceEpoch}';

    final barisBaru = Map<String, Object?>.from(data);
    barisBaru['id'] = id;

    _baris.add(barisBaru);

    return Map<String, Object?>.from(barisBaru);
  }

  Future<Map<String, Object?>> ubahStatus(String id, bool selesai) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (gagalSaatTulis) {
      throw Exception('Gagal mengubah status tugas.');
    }

    final indeks = _baris.indexWhere((item) => item['id'] == id);

    if (indeks == -1) {
      throw Exception('Tugas tidak ditemukan.');
    }

    _baris[indeks]['selesai'] = selesai ? 1 : 0;

    return Map<String, Object?>.from(_baris[indeks]);
  }

  Future<void> hapus(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (gagalSaatTulis) {
      throw Exception('Gagal menghapus tugas.');
    }

    final indeks = _baris.indexWhere((item) => item['id'] == id);

    if (indeks == -1) {
      throw Exception('Tugas tidak ditemukan.');
    }

    _baris.removeAt(indeks);
  }
}
