import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/announcement_api.dart';
import '../widgets/announcement_card.dart';
import 'announcement_detail_screen.dart';

class AnnouncementListScreen extends StatefulWidget {
  final AnnouncementApi? api;

  const AnnouncementListScreen({
    super.key,
    this.api,
  });

  @override
  State<AnnouncementListScreen> createState() =>
      _AnnouncementListScreenState();
}

class _AnnouncementListScreenState
    extends State<AnnouncementListScreen> {
  static const List<String> _kategori = [
    'Semua',
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  late final AnnouncementApi _api =
      widget.api ?? AnnouncementApi();

  late Future<List<Announcement>> _futurePengumuman;

  String _kategoriTerpilih = 'Semua';
  List<Announcement> _dataPengumuman = [];
  int _percobaan = 1;
  String _kataKunci = '';
  bool _sedangMemuatUlang = false;

  @override
  void initState() {
    super.initState();
    _futurePengumuman = _api.ambilPengumuman();
  }

  @override
  void dispose() {
    _api.tutup();
    super.dispose();
  }

  Future<void> _muatUlang() async {
  final Future<List<Announcement>> futureBaru =
      _api.ambilPengumuman();

  setState(() {
    _futurePengumuman = futureBaru;
    _percobaan++;
    _sedangMemuatUlang = true;
  });

  try {
    await futureBaru;
  } catch (_) {
    // Error ditangani oleh FutureBuilder.
  } finally {
    if (mounted) {
      setState(() {
        _sedangMemuatUlang = false;
      });
    }
  }
}

  void _pilihKategori(String kategori) {
    setState(() {
      _kategoriTerpilih = kategori;
    });
  }

  void _bukaDetail(Announcement announcement) {
  final jumlahKategori = _dataPengumuman
      .where((item) => item.category == announcement.category)
      .length;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AnnouncementDetailScreen(
        announcement: announcement,
        jumlahKategori: jumlahKategori,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portal Pengumuman TRPL',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
            Center(
    child: Text(
      'Percobaan: $_percobaan',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  ),
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBarisFilter(),
          Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Cari judul pengumuman...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
      ),
      onChanged: (value) {
        setState(() {
          _kataKunci = value.toLowerCase();
        });
      },
    ),
  ),

  const Divider(height: 1),

  if (_sedangMemuatUlang)
    const LinearProgressIndicator(minHeight: 2,),

          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _futurePengumuman,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done &&
                    !snapshot.hasData) {
                  return _buildMemuat();
                }

                if (snapshot.hasError) {
                  return _buildGagal(snapshot.error!);
                }

                final data =
                    snapshot.data ?? const <Announcement>[];
                    if (snapshot.hasData) {
                      _dataPengumuman = data;
                    }

                final tampil = data.where((announcement) {
                  final cocokKategori =
                    _kategoriTerpilih == 'Semua' ||
                    announcement.category == _kategoriTerpilih;

                  final cocokPencarian =
                     announcement.title.toLowerCase().contains(_kataKunci);

                  return cocokKategori && cocokPencarian;
                }).toList();

                if (tampil.isEmpty) {
                  return _buildKosong();
                }

                return _buildDaftar(tampil);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarisFilter() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _kategori.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final kategori = _kategori[index];

          return ChoiceChip(
            label: Text(kategori),
            selected: _kategoriTerpilih == kategori,
            onSelected: (_) => _pilihKategori(kategori),
          );
        },
      ),
    );
  }

  Widget _buildMemuat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat pengumuman dari server...'),
        ],
      ),
    );
  }

  Widget _buildGagal(Object error) {
    final pesan = error.toString().replaceFirst(
          'Exception: ',
          '',
        );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Pengumuman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pesan,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosong() {
    return RefreshIndicator(
      onRefresh: _muatUlang,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Center(
            child: Text('Tidak ada pengumuman ditemukan.'),
          ),
        ],
      ),
    );
  }

  Widget _buildDaftar(List<Announcement> items) {
    return RefreshIndicator(
      onRefresh: _muatUlang,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final announcement = items[index];

          return AnnouncementCard(
            announcement: announcement,
            onTap: () => _bukaDetail(announcement),
          );
        },
      ),
    );
  }
}