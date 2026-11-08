import 'package:flutter/material.dart';

class UbahSksScreen extends StatelessWidget {
  const UbahSksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Bobot SKS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pilih jumlah SKS baru:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(6, (index) {
            final sks = index + 1;

            return Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: Text('$sks SKS'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context, sks);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}