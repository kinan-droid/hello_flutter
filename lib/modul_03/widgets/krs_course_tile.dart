import 'package:flutter/material.dart';
import '../models/krs_course.dart';

class KrsCourseTile extends StatelessWidget {
  const KrsCourseTile({
    super.key,
    required this.course,
    required this.onTap,
    required this.onDelete,
  });

  final KrsCourse course;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '${course.sks}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          course.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${course.code} - ${course.lecturer}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus mata kuliah',
          onPressed: onDelete,
        ),
      ),
    );
  }
}