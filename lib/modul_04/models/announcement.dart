class Announcement {
  final int id;
  final String title;
  final String content;
  final String author;
  final String category;
  final String date;
  final int readCount;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.date,
    required this.readCount,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] as String? ?? 'Tanpa Judul',
      content: json['content'] as String? ??
          json['body'] as String? ??
          '',
      author: json['author'] as String? ?? 'Admin Jurusan',
      category: json['category'] as String? ?? 'Akademik',
      date: json['date'] as String? ?? '2026-09-01',
      readCount: json['readCount'] is int
          ? json['readCount'] as int
          : 0,
    );
  }

  static List<Announcement> getSampleAnnouncements() {
    return const [
      Announcement(
        id: 1,
        title: 'Jadwal Perkuliahan Semester Ganjil',
        content: 'Informasi jadwal perkuliahan semester ganjil untuk mahasiswa TRPL.',
        author: 'Bagian Akademik',
        category: 'Akademik',
        date: '2026-09-01',
        readCount: 120,
      ),
      Announcement(
        id: 2,
        title: 'Informasi Beasiswa Mahasiswa',
        content: 'Pendaftaran beasiswa bagi mahasiswa berprestasi telah dibuka.',
        author: 'Bagian Kemahasiswaan',
        category: 'Beasiswa',
        date: '2026-09-02',
        readCount: 95,
      ),
      Announcement(
        id: 3,
        title: 'Seminar Teknologi Informasi',
        content: 'Mahasiswa diundang mengikuti seminar teknologi informasi.',
        author: 'Himpunan Mahasiswa',
        category: 'Kegiatan',
        date: '2026-09-03',
        readCount: 87,
      ),
      Announcement(
        id: 4,
        title: 'Prestasi Mahasiswa TRPL',
        content: 'Selamat kepada mahasiswa TRPL yang meraih prestasi dalam kompetisi.',
        author: 'Program Studi TRPL',
        category: 'Prestasi',
        date: '2026-09-04',
        readCount: 150,
      ),
      Announcement(
        id: 5,
        title: 'Pengisian Kartu Rencana Studi',
        content: 'Mahasiswa diminta memperhatikan jadwal pengisian KRS.',
        author: 'Bagian Akademik',
        category: 'Akademik',
        date: '2026-09-05',
        readCount: 110,
      ),
      Announcement(
        id: 6,
        title: 'Pendaftaran Beasiswa Prestasi',
        content: 'Segera lengkapi persyaratan pendaftaran beasiswa.',
        author: 'Bagian Kemahasiswaan',
        category: 'Beasiswa',
        date: '2026-09-06',
        readCount: 78,
      ),
      Announcement(
        id: 7,
        title: 'Workshop Pemrograman Flutter',
        content: 'Workshop pengembangan aplikasi mobile menggunakan Flutter.',
        author: 'Laboratorium TRPL',
        category: 'Kegiatan',
        date: '2026-09-07',
        readCount: 135,
      ),
      Announcement(
        id: 8,
        title: 'Pengumuman Juara Lomba',
        content: 'Pengumuman mahasiswa yang berhasil memenangkan perlombaan.',
        author: 'Program Studi TRPL',
        category: 'Prestasi',
        date: '2026-09-08',
        readCount: 102,
      ),
      Announcement(
        id: 9,
        title: 'Informasi Ujian Tengah Semester',
        content: 'Perhatikan jadwal dan ketentuan pelaksanaan UTS.',
        author: 'Bagian Akademik',
        category: 'Akademik',
        date: '2026-09-09',
        readCount: 180,
      ),
      Announcement(
        id: 10,
        title: 'Kegiatan Pengabdian Masyarakat',
        content: 'Informasi kegiatan pengabdian masyarakat mahasiswa TRPL.',
        author: 'Himpunan Mahasiswa',
        category: 'Kegiatan',
        date: '2026-09-10',
        readCount: 67,
      ),
    ];
  }
}