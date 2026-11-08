import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskStorage {
  static const String kunciTugas = 'modul_05_tasks';
  static const String kunciVersi = 'modul_05_version';

  // Membaca data tugas dari SharedPreferences.
  Future<List<Task>> muat() async {
    final prefs = await SharedPreferences.getInstance();

    // Jika belum ada data, gunakan tiga data contoh.
    final data = prefs.getString(kunciTugas);

    if (data == null) {
      final tugasContoh = Task.getSampleTasks();
      await simpan(tugasContoh);
      return tugasContoh;
    }

    // Mengubah JSON menjadi daftar Task.
    try {
      final decoded = jsonDecode(data);

      if (decoded is! List) {
        throw const FormatException('Format data bukan daftar.');
      }

      return decoded.map((item) {
        if (item is! Map) {
          throw const FormatException('Format tugas tidak valid.');
        }

        return Task.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } on FormatException {
      rethrow;
    } on TypeError {
      throw const FormatException('Struktur data tugas rusak.');
    } catch (e) {
      throw FormatException('Gagal membaca data: $e');
    }
  }

  // Menyimpan daftar tugas sebagai satu JSON String.
  Future<void> simpan(List<Task> tugas) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(
      tugas.map((task) => task.toJson()).toList(),
    );

    final berhasil = await prefs.setString(kunciTugas, data);

    if (!berhasil) {
      throw Exception('Gagal menyimpan data tugas.');
    }

    // Versi skema untuk pembelajaran.
    await prefs.setInt(kunciVersi, 1);
  }

  // Menghapus seluruh data tersimpan.
  Future<void> hapusSemua() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kunciTugas);
    await prefs.remove(kunciVersi);
  }

  // Membuat data rusak untuk simulasi penanganan error.
  Future<void> rusakkanUntukDemo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kunciTugas, '{data-rusak');
  }
}