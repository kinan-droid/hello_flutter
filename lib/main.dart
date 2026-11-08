import 'package:flutter/material.dart';
import 'modul_02/modul_02_app.dart';
import 'modul_03/modul_03_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pengayaan/modul_03/modul_03_fase_b_app.dart';
import 'modul_04/modul_04_app.dart';
import 'modul_05/modul_05_app.dart';
import 'modul_06/modul_06_app.dart';
import 'modul_07/modul_07_app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PoliwangiProfileApp(),
    ),
  );
}

class PoliwangiProfileApp extends StatelessWidget {
  const PoliwangiProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Mahasiswa TRPL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0284C7)), // Biru Poliwangi
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final String? githubUsername = 'github.com/kinan-droid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profil Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // Placeholder sementara sebelum diisi konten profil
      body: Center(
        // ScrollView dipakai agar UI tetap aman saat orientasi landscape atau layar kecil
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar profil
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF0284C7),
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 52,
            color: Color(0xFF0284C7),
          ),
        ),
        const SizedBox(height: 16),

        // Nama mahasiswa
        const Text(
          'Kinanti Wilujeng Rizky', // Ganti dengan nama asli Anda
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),

        // Badge NIM
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'NIM: 362558302046', // Ganti dengan NIM asli Anda
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D4ED8),
                          ),
          ),
        ),
                const SizedBox(height: 24),

        // Kartu informasi akademik
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.business_rounded,
                  label: 'Jurusan',
                  value: 'Bisnis dan Informatika',
                ),
                Divider(height: 24, color: Color(0xFFF1F5F9)),
                _InfoRow(
                  icon: Icons.code_rounded,
                  label: 'Program Studi',
                  value: 'Sarjana Terapan Teknologi Rekayasa Perangkat Lunak',
                ),
                Divider(height: 24, color: Color(0xFFF1F5F9)),
                _InfoRow(
                  icon: Icons.location_on_rounded,
                  label: 'Kampus',
                  value: 'Politeknik Negeri Banyuwangi',
                ),
                Divider(height: 24, color: Color(0xFFF1F5F9)),
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Semester / TA',
                  value: 'Semester 3 (2026/2027)',
                ),
                                Divider(height: 24, color: Color(0xFFF1F5F9)),
                _InfoRow(
                  icon: Icons.code_rounded,
                  label: 'Repositori GitHub',
                  value: githubUsername ?? '(belum diatur)',
                ),
                Divider(height: 24, color: Color(0xFFF1F5F9)),
                _InfoRow(
                  icon: Icons.star_rounded,
                  label: 'Fokus Keahlian',
                  value: 'Mobile UI/UX & Flutter Development',
                ),
              ],
            ),
          ),
        ),
                const SizedBox(height: 24),

        // Tombol verifikasi dengan feedback SnackBar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Status: Mahasiswa Aktif TRPL — Angkatan 2025'),
                  backgroundColor: Color(0xFF0284C7),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            icon: const Icon(Icons.verified_user_rounded),
            label: const Text('Verifikasi Status Mahasiswa'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Modul02App(),
                ),
              );
            },
            icon: const Icon(Icons.dashboard_rounded),
            label: const Text('Buka Dashboard Akademik'),
          ),
        ),
                const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Modul03App(),
                ),
              );
            },
            icon: const Icon(Icons.assignment_rounded),
            label: const Text('Buka Aplikasi KRS'),
          ),
        ),
                const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Modul03FaseBApp(),
                ),
              );
            },
            icon: const Icon(Icons.route_rounded),
            label: const Text('Modul 03 Fase B - Pengayaan'),
          ),
        ),
        const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Modul04App(),
        ),
      );
    },
    icon: const Icon(Icons.cloud_download_rounded),
    label: const Text('Modul 04 - Future & REST API Dasar'),
  ),
),
const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Modul05App(),
        ),
      );
    },
    icon: const Icon(Icons.checklist_rounded),
    label: const Text('Modul 05 - Task Manager'),
  ),
),
const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Modul06App(),
        ),
      );
    },
    icon: const Icon(Icons.lock_person_rounded),
    label: const Text('Modul 06 - Login & Session'),
  ),
),
const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Modul07App(),
        ),
      );
    },
    icon: const Icon(Icons.layers_rounded),
    label: const Text('Modul 07 - Arsitektur Berlapis & MVVM'),
  ),
),
      ],
    ),
  ),
      )
    );
  }
}

// Widget reusable untuk tiap baris informasi profil
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF0284C7)),
        ),
        const SizedBox(width: 14),

        // Expanded agar teks panjang otomatis wrap ke bawah dan tidak overflow
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}