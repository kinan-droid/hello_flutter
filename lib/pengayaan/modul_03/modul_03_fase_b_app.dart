import 'package:flutter/material.dart';

import 'app_router.dart';

class Modul03FaseBApp extends StatelessWidget {
  const Modul03FaseBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Modul 03 Fase B - KRS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      routerConfig: modul03Router,
    );
  }
}