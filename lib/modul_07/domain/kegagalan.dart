sealed class Kegagalan {
  final String pesan;

  const Kegagalan(this.pesan);
}

class JudulKosong extends Kegagalan {
  const JudulKosong() : super('Judul tugas tidak boleh kosong.');
}

class TugasTidakDitemukan extends Kegagalan {
  const TugasTidakDitemukan() : super('Tugas tidak ditemukan.');
}

class SumberDataGagal extends Kegagalan {
  const SumberDataGagal([super.pesan = 'Terjadi kesalahan pada sumber data.']);
}
