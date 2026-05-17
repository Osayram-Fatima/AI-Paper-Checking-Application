// lib/code/frontend/session/class_preferences.dart
// ─────────────────────────────────────────────────────────────
//  Persists the teacher's selected class across app restarts
//  using shared_preferences.
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_paper_checking/code/frontend/services/class_service.dart';

class ClassPreferences {
  static const _keyClassId = 'selected_class_id';
  static const _keyClassName = 'selected_class_name';
  static const _keySubject = 'selected_class_subject';
  static const _keyJoinCode = 'selected_class_join_code';
  static const _keyCreatedAt = 'selected_class_created_at';
  static const _keyStudentCount = 'selected_class_student_count';

  /// Save the selected class locally.
  static Future<void> saveSelectedClass(ClassModel cls) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyClassId, cls.classId);
    await prefs.setString(_keyClassName, cls.className);
    await prefs.setString(_keySubject, cls.subjectName ?? '');
    await prefs.setString(_keyJoinCode, cls.joinCode);
    await prefs.setString(_keyCreatedAt, cls.createdAt.toIso8601String());
    await prefs.setInt(_keyStudentCount, cls.studentCount);
  }

  /// Load the previously selected class (returns null if none saved).
  static Future<ClassModel?> loadSelectedClass() async {
    final prefs = await SharedPreferences.getInstance();
    final classId = prefs.getInt(_keyClassId);
    if (classId == null) return null;

    return ClassModel(
      classId: classId,
      className: prefs.getString(_keyClassName) ?? '',
      subjectName: (prefs.getString(_keySubject) ?? '').isEmpty
          ? null
          : prefs.getString(_keySubject),
      joinCode: prefs.getString(_keyJoinCode) ?? '',
      createdAt:
          DateTime.tryParse(prefs.getString(_keyCreatedAt) ?? '') ??
          DateTime.now(),
      studentCount: prefs.getInt(_keyStudentCount) ?? 0,
    );
  }

  /// Clear the saved class (e.g. on logout or class deletion).
  static Future<void> clearSelectedClass() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyClassId);
    await prefs.remove(_keyClassName);
    await prefs.remove(_keySubject);
    await prefs.remove(_keyJoinCode);
    await prefs.remove(_keyCreatedAt);
    await prefs.remove(_keyStudentCount);
  }
}
