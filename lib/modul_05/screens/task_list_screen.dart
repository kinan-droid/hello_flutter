import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_storage.dart';
import '../widgets/task_tile.dart';

enum _SaringTugas {
  semua,
  belumSelesai,
  selesai,
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskStorage _storage = TaskStorage();

  List<Task> _tugas = [];
  bool _memuat = true;
  String? _pesanError;
  _SaringTugas _saring = _SaringTugas.semua;

  @override
  void initState() {
    super.initState();
    unawaited(_muat());
  }

  // Memuat data dari SharedPreferences.
  Future<void> _muat() async {
    setState(() {
      _memuat = true;
      _pesanError = null;
    });

    try {
      // Simulasi loading lambat jika LAMBAT=true.
      const lambat = bool.fromEnvironment('LAMBAT');

      if (lambat) {
        await Future.delayed(const Duration(seconds: 2));
      }

      final hasil = await _storage.muat();

      if (!mounted) return;

      setState(() {
        _tugas = hasil;
        _memuat = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _pesanError = e.toString();
        _memuat = false;
      });
    }
  }

  // Menyimpan perubahan daftar tugas.
  Future<void> _simpanDaftar(List<Task> daftarBaru) async {
    final daftarLama = List<Task>.of(_tugas);

    setState(() {
      _tugas = daftarBaru;
    });

    try {
      await _storage.simpan(daftarBaru);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _tugas = daftarLama;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan tugas: $e'),
        ),
      );
    }
  }

  // Menampilkan formulir penambahan tugas.
  Future<void> _tambahTugas() async {
    final judulController = TextEditingController();
    final mataKuliahController = TextEditingController();

    int prioritas = 2;

    final hasil = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Tugas'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        labelText: 'Judul tugas',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: mataKuliahController,
                      decoration: const InputDecoration(
                        labelText: 'Mata kuliah',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: prioritas,
                      decoration: const InputDecoration(
                        labelText: 'Prioritas',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Tinggi'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Sedang'),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text('Rendah'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            prioritas = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    if (judulController.text.trim().isEmpty ||
                        mataKuliahController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Semua kolom wajib diisi.'),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (hasil == true && mounted) {
      final tugasBaru = Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: judulController.text.trim(),
        course: mataKuliahController.text.trim(),
        done: false,
        createdAt: DateTime.now().toIso8601String(),
        prioritas: prioritas,
      );

      await _simpanDaftar([
        tugasBaru,
        ..._tugas,
      ]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil ditambahkan.'),
          ),
        );
      }
    }

    judulController.dispose();
    mataKuliahController.dispose();
  }

  // Mengubah status selesai tugas.
  Future<void> _ubahStatus(Task task) async {
    final daftarBaru = _tugas.map((item) {
      if (item.id == task.id) {
        return item.copyWith(done: !item.done);
      }

      return item;
    }).toList();

    await _simpanDaftar(daftarBaru);
  }

  // Menghapus tugas dan menyediakan fitur undo.
  Future<void> _hapus(Task task) async {
    final indeks = _tugas.indexWhere(
      (item) => item.id == task.id,
    );

    final daftarBaru = List<Task>.of(_tugas)
      ..removeWhere((item) => item.id == task.id);

    await _simpanDaftar(daftarBaru);

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${task.title} dihapus.'),
        action: SnackBarAction(
          label: 'URUNGKAN',
          onPressed: () {
            final hasil = List<Task>.of(_tugas);

            hasil.insert(
              indeks.clamp(0, hasil.length),
              task,
            );

            unawaited(_simpanDaftar(hasil));
          },
        ),
      ),
    );
  }

  // Menghapus seluruh tugas yang sudah selesai.
  Future<void> _hapusSelesai() async {
    final daftarBaru = _tugas
        .where((task) => !task.done)
        .toList();

    await _simpanDaftar(daftarBaru);
  }

  // Menampilkan simulasi data rusak.
  Future<void> _rusakkanData() async {
    await _storage.rusakkanUntukDemo();
    await _muat();
  }

  // Memulihkan aplikasi dengan menghapus data rusak.
  Future<void> _bersihkanData() async {
    await _storage.hapusSemua();
    await _muat();
  }

  List<Task> get _tugasTersaring {
    switch (_saring) {
      case _SaringTugas.semua:
        return _tugas;
      case _SaringTugas.belumSelesai:
        return _tugas.where((task) => !task.done).toList();
      case _SaringTugas.selesai:
        return _tugas.where((task) => task.done).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'rusak':
                  unawaited(_rusakkanData());
                  break;
                case 'bersihkan':
                  unawaited(_bersihkanData());
                  break;
                case 'hapus_selesai':
                  unawaited(_hapusSelesai());
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'hapus_selesai',
                child: Text('Hapus tugas selesai'),
              ),
              PopupMenuItem(
                value: 'rusak',
                child: Text('Rusakkan data (demo)'),
              ),
              PopupMenuItem(
                value: 'bersihkan',
                child: Text('Hapus Data Rusak'),
              ),
            ],
          ),
        ],
      ),
      body: _tampilanIsi(),
      floatingActionButton: FloatingActionButton(
        onPressed: _memuat || _pesanError != null
            ? null
            : _tambahTugas,
        tooltip: 'Tambah tugas',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tampilanIsi() {
    // Kondisi 1: Loading.
    if (_memuat) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Kondisi 2: Error.
    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 56,
              ),
              const SizedBox(height: 12),
              const Text(
                'Data tugas tidak dapat dibaca.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _pesanError!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _muat,
                child: const Text('Coba Lagi'),
              ),
              TextButton(
                onPressed: _bersihkanData,
                child: const Text('Hapus Data Rusak'),
              ),
            ],
          ),
        ),
      );
    }

    // Kondisi 3: Empty.
    if (_tugas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'Belum ada tugas.',
              style: TextStyle(fontSize: 16),
            ),
            Text('Tekan tombol + untuk menambahkan tugas.'),
          ],
        ),
      );
    }

    // Kondisi 4: Success.
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Semua'),
                selected: _saring == _SaringTugas.semua,
                onSelected: (_) {
                  setState(() {
                    _saring = _SaringTugas.semua;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Belum selesai'),
                selected: _saring == _SaringTugas.belumSelesai,
                onSelected: (_) {
                  setState(() {
                    _saring = _SaringTugas.belumSelesai;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Selesai'),
                selected: _saring == _SaringTugas.selesai,
                onSelected: (_) {
                  setState(() {
                    _saring = _SaringTugas.selesai;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: _tugasTersaring.isEmpty
              ? const Center(
                  child: Text('Tidak ada tugas pada filter ini.'),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final lebar = constraints.maxWidth;
                    final jumlahKolom = lebar >= 700 ? 2 : 1;

                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: jumlahKolom,
                        mainAxisExtent: 150,
                      ),
                      itemCount: _tugasTersaring.length,
                      itemBuilder: (context, index) {
                        final task = _tugasTersaring[index];

                        return TaskTile(
                          task: task,
                          onChanged: () {
                            unawaited(_ubahStatus(task));
                          },
                          onDelete: () {
                            unawaited(_hapus(task));
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}