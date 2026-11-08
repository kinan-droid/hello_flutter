import 'package:flutter/foundation.dart';

import '../domain/kegagalan.dart';
import '../domain/repositori_tugas.dart';
import 'state_daftar_tugas.dart';

class ViewModelDaftarTugas extends ChangeNotifier {
  ViewModelDaftarTugas(this._repositori);

  final RepositoriTugas _repositori;

  StateDaftarTugas _state = const StateDaftarTugas();

  StateDaftarTugas get state => _state;

  bool _dibuang = false;

  void _ubah(StateDaftarTugas stateBaru) {
    if (_dibuang) return;

    _state = stateBaru;
    notifyListeners();
  }

  String _pesanError(Object error) {
    if (error is Kegagalan) return error.pesan;
    return 'Terjadi kesalahan yang tidak diketahui.';
  }

  Future<void> muat() async {
    _ubah(StateDaftarTugas(status: StatusMuat.memuat, daftar: _state.daftar));

    try {
      final daftar = await _repositori.muat();

      _ubah(StateDaftarTugas(status: StatusMuat.siap, daftar: daftar));
    } catch (error) {
      _ubah(
        StateDaftarTugas(
          status: StatusMuat.gagal,
          daftar: _state.daftar,
          pesanGagal: _pesanError(error),
        ),
      );
    }
  }

  Future<bool> tambah({
    required String judul,
    required String mataKuliah,
    required int prioritas,
  }) async {
    try {
      await _repositori.tambah(
        judul: judul,
        mataKuliah: mataKuliah,
        prioritas: prioritas,
      );

      await muat();
      return state.status == StatusMuat.siap;
    } catch (error) {
      _ubah(
        StateDaftarTugas(
          status: _state.status,
          daftar: _state.daftar,
          pesanGagal: _pesanError(error),
        ),
      );
      return false;
    }
  }

  Future<bool> ubahStatus({required String id, required bool selesai}) async {
    try {
      await _repositori.ubahStatus(id: id, selesai: selesai);

      await muat();
      return state.status == StatusMuat.siap;
    } catch (error) {
      _ubah(
        StateDaftarTugas(
          status: _state.status,
          daftar: _state.daftar,
          pesanGagal: _pesanError(error),
        ),
      );
      return false;
    }
  }

  Future<bool> hapus(String id) async {
    try {
      await _repositori.hapus(id);

      await muat();
      return state.status == StatusMuat.siap;
    } catch (error) {
      _ubah(
        StateDaftarTugas(
          status: _state.status,
          daftar: _state.daftar,
          pesanGagal: _pesanError(error),
        ),
      );
      return false;
    }
  }

  @override
  void dispose() {
    _dibuang = true;
    super.dispose();
  }
}
