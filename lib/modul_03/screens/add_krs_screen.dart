import 'package:flutter/material.dart';
import '../models/krs_course.dart';

class AddKrsScreen extends StatefulWidget {
  const AddKrsScreen({super.key});

  @override
  State<AddKrsScreen> createState() => _AddKrsScreenState();
}

class _AddKrsScreenState extends State<AddKrsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _sksController = TextEditingController(text: '3');

  bool _isSaving = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _lecturerController.dispose();
    _sksController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final courseBaru = KrsCourse(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      lecturer: _lecturerController.text.trim(),
      sks: int.parse(_sksController.text.trim()),
      description: 'Mata kuliah tambahan pada semester ini.',
    );

    Navigator.pop(context, courseBaru);
  }

  String? _validasiWajib(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi.';
    }
    return null;
  }

  String? _validasiSks(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Jumlah SKS wajib diisi.';
    }

    final sks = int.tryParse(value.trim());

    if (sks == null || sks < 1 || sks > 6) {
      return 'Masukkan jumlah SKS antara 1 sampai 6.';
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulir KRS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  hintText: 'Contoh: TRPL504',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: _validasiWajib,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.menu_book),
                ),
                validator: _validasiWajib,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lecturerController,
                decoration: const InputDecoration(
                  labelText: 'Nama Dosen Pengampu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: _validasiWajib,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _sksController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS',
                  hintText: 'Masukkan 1 sampai 6',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: _validasiSks,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _simpan,
                  icon: const Icon(Icons.save),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : 'Simpan Mata Kuliah',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}