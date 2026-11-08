import 'package:flutter/material.dart';

import '../domain/tugas.dart';
import '../presentation/state_daftar_tugas.dart';
import '../presentation/view_model_daftar_tugas.dart';
import '../widgets/kartu_tugas.dart';

class DaftarTugasScreen extends StatefulWidget {
  const DaftarTugasScreen({super.key, required this.viewModel});

  final ViewModelDaftarTugas viewModel;

  @override
  State<DaftarTugasScreen> createState() => _DaftarTugasScreenState();
}

class _DaftarTugasScreenState extends State<DaftarTugasScreen> {
  final _judulController = TextEditingController();
  final _mataKuliahController = TextEditingController();

  int _prioritas = 2;
  bool _sedangMenambah = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.muat();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _mataKuliahController.dispose();
    super.dispose();
  }

  Future<void> _tambahTugas() async {
    if (_sedangMenambah) return;

    setState(() {
      _sedangMenambah = true;
    });

    final berhasil = await widget.viewModel.tambah(
      judul: _judulController.text,
      mataKuliah: _mataKuliahController.text,
      prioritas: _prioritas,
    );

    if (!mounted) return;

    setState(() {
      _sedangMenambah = false;
    });

    if (berhasil) {
      _judulController.clear();
      _mataKuliahController.clear();
      _prioritas = 2;
    }

    final pesan = widget.viewModel.state.pesanGagal;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berhasil
              ? 'Tugas berhasil ditambahkan.'
              : pesan ?? 'Gagal menambahkan tugas.',
        ),
      ),
    );
  }

  Future<void> _ubahStatus(Tugas tugas, bool selesai) async {
    await widget.viewModel.ubahStatus(id: tugas.id, selesai: selesai);
  }

  Future<void> _hapusTugas(Tugas tugas) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Hapus tugas "${tugas.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || setuju != true) return;

    final berhasil = await widget.viewModel.hapus(tugas.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berhasil
              ? 'Tugas berhasil dihapus.'
              : widget.viewModel.state.pesanGagal ?? 'Gagal menghapus tugas.',
        ),
      ),
    );
  }

  Widget _bangunDaftar(StateDaftarTugas state) {
    if (state.status == StatusMuat.memuat) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == StatusMuat.gagal) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 8),
            Text(state.pesanGagal ?? 'Gagal memuat tugas.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: widget.viewModel.muat,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (state.kosong) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48),
            SizedBox(height: 8),
            Text('Belum ada tugas.'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.daftar.length,
      itemBuilder: (context, index) {
        final tugas = state.daftar[index];

        return KartuTugas(
          tugas: tugas,
          onUbahStatus: (selesai) {
            _ubahStatus(tugas, selesai);
          },
          onHapus: () {
            _hapusTugas(tugas);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modul 07 - Daftar Tugas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Tugas',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _mataKuliahController,
                  decoration: const InputDecoration(
                    labelText: 'Mata Kuliah',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  initialValue: _prioritas,
                  decoration: const InputDecoration(
                    labelText: 'Prioritas',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1 - Tinggi')),
                    DropdownMenuItem(value: 2, child: Text('2 - Sedang')),
                    DropdownMenuItem(value: 3, child: Text('3 - Rendah')),
                  ],
                  onChanged: (nilai) {
                    if (nilai != null) {
                      setState(() {
                        _prioritas = nilai;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _sedangMenambah ? null : _tambahTugas,
                    icon: const Icon(Icons.add),
                    label: Text(
                      _sedangMenambah ? 'Menyimpan...' : 'Tambah Tugas',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              final state = widget.viewModel.state;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Tugas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Belum selesai: ${state.jumlahBelumSelesai}'),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                return _bangunDaftar(widget.viewModel.state);
              },
            ),
          ),
        ],
      ),
    );
  }
}
