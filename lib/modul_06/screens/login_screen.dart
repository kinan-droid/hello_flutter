import 'dart:async';
import 'package:flutter/material.dart';

import '../models/sesi_pengguna.dart';
import '../services/auth_api.dart';
import '../services/sesi_memori.dart';
import '../widgets/field_kata_sandi.dart';
import '../widgets/kartu_sesi.dart';

enum StatusAuth {
  memeriksa,
  keluar,
  memproses,
  masuk,
  gagal,
}

class LoginScreen extends StatefulWidget {
  final AuthApi api;
  final SesiMemori sesiMemori;
  final DateTime Function() jam;

  const LoginScreen({
    super.key,
    required this.api,
    required this.sesiMemori,
    this.jam = DateTime.now,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _sandi = TextEditingController();

  StatusAuth _status = StatusAuth.memeriksa;
  String? _pesanGagal;
  SesiPengguna? _sesi;
  bool _sedangKeluar = false;
  Timer? _timerSesi;
  bool _loginDibatalkan = false;

  bool get _sibuk => _status == StatusAuth.memproses;

  @override
  void initState() {
    super.initState();
    _pulihkanSesi();
  }

  Future<void> _pulihkanSesi() async {
    final SesiPengguna? sesi = widget.sesiMemori.baca();

    if (sesi == null) {
      if (!mounted) return;
      setState(() {
        _status = StatusAuth.keluar;
      });
      return;
    }

    if (sesi.sudahKedaluwarsa(widget.jam())) {
      await widget.sesiMemori.hapus();

      if (!mounted) return;
      setState(() {
        _sesi = null;
        _status = StatusAuth.gagal;
        _pesanGagal = 'Sesi sudah kedaluwarsa. Silakan login kembali.';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _sesi = sesi;
      _status = StatusAuth.masuk;
    });
    _mulaiPantauSesi();
  }

  void _mulaiPantauSesi() {
  _timerSesi?.cancel();

  _timerSesi = Timer.periodic(
    const Duration(seconds: 1),
    (timer) async {
      if (!mounted || _sesi == null) {
        timer.cancel();
        return;
      }

      if (_sesi!.sudahKedaluwarsa(widget.jam())) {
        timer.cancel();
        await widget.sesiMemori.hapus();

        if (!mounted) return;

        setState(() {
          _sesi = null;
          _status = StatusAuth.gagal;
          _pesanGagal = 'Sesi telah kedaluwarsa. Silakan login kembali.';
        });
      } else {
        setState(() {});
      }
    },
  );
}

  Future<void> _kirim() async {
    if (_sibuk) return;

    FocusScope.of(context).unfocus();

    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    _loginDibatalkan = false;

    setState(() {
      _status = StatusAuth.memproses;
      _pesanGagal = null;
    });

    try {
      final SesiPengguna sesi = await widget.api.masuk(
        email: _email.text,
        sandi: _sandi.text,
      );

      if (_loginDibatalkan || !mounted) return;

      await widget.sesiMemori.simpan(sesi);

      if (_loginDibatalkan || !mounted) return;

      setState(() {
        _sesi = sesi;
        _status = StatusAuth.masuk;
        _sandi.clear();
      });
      _mulaiPantauSesi();
    } on AuthException catch (e) {
      if (_loginDibatalkan) return;

      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = '${e.pesan} (Kode: ${e.kode})';
      });
    } catch (e) {
      debugPrint('Kesalahan login: $e');

      if (_loginDibatalkan) return;

      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = 'Terjadi kesalahan. Silakan coba lagi.';
      });
    }
  }

  void _batalkanLogin() {
  if (!_sibuk) return;

  _loginDibatalkan = true;

  setState(() {
    _status = StatusAuth.gagal;
    _pesanGagal = 'Proses login dibatalkan.';
  });
}

  Future<void> _keluar() async {
    if (_sedangKeluar) return;

    _timerSesi?.cancel();

    setState(() {
      _sedangKeluar = true;
    });

    await widget.sesiMemori.hapus();

    if (!mounted) return;

    setState(() {
      _sesi = null;
      _status = StatusAuth.keluar;
      _pesanGagal = null;
      _sedangKeluar = false;
      _email.clear();
      _sandi.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul 06 - Login & Session'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _bangunIsi(),
      ),
    );
  }

  Widget _bangunIsi() {
    switch (_status) {
      case StatusAuth.memeriksa:
        return const Center(
          child: CircularProgressIndicator(),
        );

      case StatusAuth.masuk:
        if (_sesi == null) {
          return _bangunFormLogin();
        }
        return _bangunBeranda();

      case StatusAuth.keluar:
      case StatusAuth.memproses:
      case StatusAuth.gagal:
        return _bangunFormLogin();
    }
  }

  Widget _bangunFormLogin() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const Icon(
          Icons.lock_person_outlined,
          size: 72,
          color: Color(0xFF0284C7),
        ),
        const SizedBox(height: 16),
        Text(
          'Selamat Datang',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan login menggunakan akun praktikum.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        if (_pesanGagal != null) ...[
          _KotakPesan(pesan: _pesanGagal!),
          const SizedBox(height: 16),
        ],

        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                enabled: !_sibuk,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'nama@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (nilai) {
                  final String email = nilai?.trim() ?? '';

                  if (email.isEmpty) {
                    return 'Email wajib diisi.';
                  }

                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Format email tidak valid.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              FieldKataSandi(
                controller: _sandi,
                enabled: !_sibuk,
                onFieldSubmitted: (_) => _kirim(),
                validator: (nilai) {
                  final String sandi = nilai ?? '';

                  if (sandi.isEmpty) {
                    return 'Kata sandi wajib diisi.';
                  }

                  if (sandi.length < 8) {
                    return 'Kata sandi minimal 8 karakter.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _sibuk ? null : _kirim,
                  icon: _sibuk
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _sibuk ? 'Sedang memproses...' : 'Login',
                  ),
                ),
              ),
              if (_sibuk)
  TextButton.icon(
    onPressed: _batalkanLogin,
    icon: const Icon(Icons.cancel_outlined),
    label: const Text('Batalkan Login'),
  ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        _KotakInfoDemo(
          onIsiOtomatis: () {
            _email.text = AuthApi.emailDemo;
            _sandi.text = AuthApi.sandiDemo;
          },
        ),
      ],
    );
  }

  Widget _bangunBeranda() {
    final SesiPengguna sesi = _sesi!;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Login Berhasil!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kamu sudah masuk ke halaman utama praktikum.',
        ),
        const SizedBox(height: 20),
        KartuSesi(
          sesi: sesi,
          sekarang: widget.jam(),
          sedangKeluar: _sedangKeluar,
          onKeluar: _keluar,
        ),
        const SizedBox(height: 16),
        const _KotakPeringatanMemori(),
      ],
    );
  }

  @override
  void dispose() {
    _timerSesi?.cancel();
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }
}

class _KotakPesan extends StatelessWidget {
  final String pesan;

  const _KotakPesan({
    required this.pesan,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warna.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: warna.onErrorContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              pesan,
              style: TextStyle(color: warna.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _KotakInfoDemo extends StatelessWidget {
  final VoidCallback onIsiOtomatis;

  const _KotakInfoDemo({
    required this.onIsiOtomatis,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Akun Demo Praktikum',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Email: student@trpl.test'),
            const Text('Kata sandi: belajar123'),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onIsiOtomatis,
              icon: const Icon(Icons.edit),
              label: const Text('Isi Otomatis'),
            ),
          ],
        ),
      ),
    );
  }
}

class _KotakPeringatanMemori extends StatelessWidget {
  const _KotakPeringatanMemori();

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: warna.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: warna.onTertiaryContainer,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Sesi ini hanya disimpan di memori aplikasi. '
              'Jika proses aplikasi dihentikan, sesi akan hilang '
              'dan kamu perlu login kembali.',
            ),
          ),
        ],
      ),
    );
  }
}