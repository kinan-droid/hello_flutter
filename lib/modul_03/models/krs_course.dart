// Model data untuk mata kuliah KRS
class KrsCourse {
  const KrsCourse({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.sks,
    this.description = '',
  });

  final String code;
  final String name;
  final String lecturer;
  final int sks;
  final String description;

  // Data awal mata kuliah
  static List<KrsCourse> getInitialCourses() {
    return const [
      KrsCourse(
        code: 'TRPL501',
        name: 'Pemrograman Perangkat Bergerak',
        lecturer: 'Sepyan Purnama Kristanto, M.Kom.',
        sks: 3,
        description: 'Mempelajari pengembangan aplikasi mobile menggunakan Flutter.',
      ),
      KrsCourse(
        code: 'TRPL502',
        name: 'Basis Data Lanjut',
        lecturer: 'Dosen Pengampu Basis Data',
        sks: 3,
        description: 'Mempelajari pengelolaan basis data tingkat lanjut.',
      ),
      KrsCourse(
        code: 'TRPL503',
        name: 'Pemrograman Berorientasi Objek',
        lecturer: 'Dosen Pengampu PBO',
        sks: 3,
        description: 'Mempelajari konsep pemrograman berorientasi objek.',
      ),
    ];
  }
}