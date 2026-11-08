class Task {
  final String id;
  final String title;
  final String course;
  final bool done;
  final String createdAt;
  final int prioritas;

  const Task({
    required this.id,
    required this.title,
    required this.course,
    required this.done,
    required this.createdAt,
    required this.prioritas,
  });

  // Mengubah objek Task menjadi Map untuk JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'done': done,
      'createdAt': createdAt,
      'prioritas': prioritas,
    };
  }

  // Membuat objek Task dari data JSON.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      course: json['course'] as String,
      done: json['done'] as bool,
      createdAt: json['createdAt'] as String,
      prioritas: json['prioritas'] as int,
    );
  }

  // Membuat salinan Task dengan beberapa nilai yang bisa diubah.
  Task copyWith({
    String? id,
    String? title,
    String? course,
    bool? done,
    String? createdAt,
    int? prioritas,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      prioritas: prioritas ?? this.prioritas,
    );
  }

  // Tiga data contoh saat aplikasi pertama kali dibuka.
  static List<Task> getSampleTasks() {
    return [
      Task(
        id: '1',
        title: 'Menyelesaikan Modul 4',
        course: 'Pemrograman Perangkat Bergerak',
        done: false,
        createdAt: '2026-11-08',
        prioritas: 1,
      ),
      Task(
        id: '2',
        title: 'Mempelajari SharedPreferences',
        course: 'Pemrograman Perangkat Bergerak',
        done: false,
        createdAt: '2026-11-08',
        prioritas: 2,
      ),
      Task(
        id: '3',
        title: 'Membaca materi Modul 5',
        course: 'Pemrograman Perangkat Bergerak',
        done: true,
        createdAt: '2026-11-08',
        prioritas: 3,
      ),
    ];
  }

  // Label prioritas.
  String get labelPrioritas {
    switch (prioritas) {
      case 1:
        return 'Tinggi';
      case 2:
        return 'Sedang';
      case 3:
        return 'Rendah';
      default:
        return 'Normal';
    }
  }

  // Mengubah tanggal menjadi format yang mudah dibaca.
  String get tanggalFormatted {
    final tanggal = DateTime.tryParse(createdAt);

    if (tanggal == null) {
      return createdAt;
    }

    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }
}