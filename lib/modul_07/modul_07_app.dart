import 'package:flutter/material.dart';

import 'data/repositori_tugas_memori.dart';
import 'data/sumber_tugas_memori.dart';
import 'presentation/view_model_daftar_tugas.dart';
import 'screens/daftar_tugas_screen.dart';

class Modul07App extends StatefulWidget {
  const Modul07App({super.key});

  @override
  State<Modul07App> createState() => _Modul07AppState();
}

class _Modul07AppState extends State<Modul07App> {
  late final SumberTugasMemori _sumber;
  late final RepositoriTugasMemori _repositori;
  late final ViewModelDaftarTugas _viewModel;

  @override
  void initState() {
    super.initState();

    _sumber = SumberTugasMemori();
    _repositori = RepositoriTugasMemori(_sumber);
    _viewModel = ViewModelDaftarTugas(_repositori);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modul 07 - MVVM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: DaftarTugasScreen(viewModel: _viewModel),
    );
  }
}
