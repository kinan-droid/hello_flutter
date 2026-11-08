class Tugas {
  final String id;
  final String judul;
  final String mataKuliah;
  final bool selesai;
  final String dibuatPada;
  final int prioritas;

  const Tugas({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.selesai,
    required this.dibuatPada,
    required this.prioritas,
  });

  Tugas salinDengan({
    String? id,
    String? judul,
    String? mataKuliah,
    bool? selesai,
    String? dibuatPada,
    int? prioritas,
  }) {
    return Tugas(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      mataKuliah: mataKuliah ?? this.mataKuliah,
      selesai: selesai ?? this.selesai,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      prioritas: prioritas ?? this.prioritas,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Tugas && other.id == id && other.selesai == selesai;
  }

  @override
  int get hashCode => Object.hash(id, selesai);
}
