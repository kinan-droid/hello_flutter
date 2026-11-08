import 'package:flutter_test/flutter_test.dart';

import 'package:hello_flutter/modul_07/data/repositori_tugas_memori.dart';
import 'package:hello_flutter/modul_07/data/sumber_tugas_memori.dart';
import 'package:hello_flutter/modul_07/domain/kegagalan.dart';

void main() {
  late SumberTugasMemori sumber;
  late RepositoriTugasMemori repositori;

  setUp(() {
    sumber = SumberTugasMemori();
    repositori = RepositoriTugasMemori(
      sumber,
      jam: () => DateTime(2026, 11, 8),
    );
  });

  test('Memuat daftar tugas awal', () async {
    final daftar = await repositori.muat();

    expect(daftar.length, 3);
    expect(daftar.first.judul, 'Mempelajari Repository Pattern');
  });

  test('Menambahkan tugas baru', () async {
    final tugas = await repositori.tambah(
      judul: 'Mengerjakan laporan',
      mataKuliah: 'Pemrograman Flutter',
      prioritas: 1,
    );

    expect(tugas.judul, 'Mengerjakan laporan');
    expect(tugas.mataKuliah, 'Pemrograman Flutter');
    expect(tugas.prioritas, 1);
    expect(tugas.selesai, false);
  });

  test('Menolak judul tugas kosong', () async {
    expect(
      () => repositori.tambah(
        judul: '   ',
        mataKuliah: 'Pemrograman Flutter',
        prioritas: 2,
      ),
      throwsA(isA<JudulKosong>()),
    );
  });

  test('Mengubah status tugas', () async {
    final tugas = await repositori.ubahStatus(
      id: 'T001',
      selesai: true,
    );

    expect(tugas.selesai, true);
  });

  test('Menghapus tugas', () async {
    await repositori.hapus('T001');

    final daftar = await repositori.muat();

    expect(
      daftar.any((tugas) => tugas.id == 'T001'),
      false,
    );
    expect(daftar.length, 2);
  });
}