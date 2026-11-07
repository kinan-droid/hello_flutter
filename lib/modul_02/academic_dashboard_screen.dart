import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

class AcademicDashboardScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback? onToggleTheme;

  const AcademicDashboardScreen({
    super.key,
    this.themeMode = ThemeMode.light,
    this.onToggleTheme,
  });

  static final List<Course> _courses = Course.getSampleCourses();

  bool get _isDarkMode => themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Akademik TRPL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: onToggleTheme,
            tooltip: _isDarkMode
                ? 'Aktifkan Light Mode'
                : 'Aktifkan Dark Mode',
            icon: Icon(
              _isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          // Smartphone: 1 kolom
          if (constraints.maxWidth < 600) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const HeaderBanner(),
                const SizedBox(height: 16),

                Text(
                  'Mata Kuliah Semester 3 (${_courses.length} Terdaftar)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ..._courses.map(
                  (course) => CourseCard(course: course),
                ),
              ],
            );
          }

          // Tablet / Landscape: 2 kolom
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom kiri
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: const HeaderBanner(),
                ),
              ),

              // Kolom kanan
              Expanded(
                flex: 2,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 340,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 240,
                  ),
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                      course: _courses[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}