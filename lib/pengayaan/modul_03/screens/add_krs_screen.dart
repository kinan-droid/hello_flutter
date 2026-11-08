import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../modul_03/models/krs_course.dart';
import '../krs_provider.dart';

class AddKrsScreen extends ConsumerStatefulWidget {
  const AddKrsScreen({super.key});

  @override
  ConsumerState<AddKrsScreen> createState() => _AddKrsScreenState();
}

class _AddKrsScreenState extends ConsumerState<AddKrsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _sksController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _lecturerController.dispose();
    _sksController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _simpanKrs() {
    if (!_formKey.currentState!.validate()) return;

    final course = KrsCourse(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      lecturer: _lecturerController.text.trim(),
      sks: int.parse(_sksController.text.trim()),
      description: _descriptionController.text.trim(),
    );

    final pesan = ref
        .read(krsProvider.notifier)
        .tambahMataKuliah(course);

    if (pesan != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesan)),
      );
      return;
    }

    context.pop();
  }

  String? _validasiWajib(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi.';
    }
    return null;
  }

  String? _validasiSks(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'SKS wajib diisi.';
    }

    final sks = int.tryParse(value);

    if (sks == null || sks < 1 || sks > 6) {
      return 'Masukkan SKS antara 1 sampai 6.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mata Kuliah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiWajib,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiWajib,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lecturerController,
                decoration: const InputDecoration(
                  labelText: 'Nama Dosen',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiWajib,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sksController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS (1-6)',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiSks,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _simpanKrs,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Mata Kuliah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}