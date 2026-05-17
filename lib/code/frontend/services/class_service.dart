// lib/code/frontend/services/class_service.dart
// ─────────────────────────────────────────────────────────────
//  All HTTP calls for class management.
//  Relies on your existing UserSession for base URL + token.
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_paper_checking/code/frontend/session/user_session.dart';

// ── Data Models ───────────────────────────────────────────────

class ClassModel {
  final int classId;
  final String className;
  final String? subjectName;
  final String joinCode;
  final DateTime createdAt;
  final int studentCount;

  const ClassModel({
    required this.classId,
    required this.className,
    this.subjectName,
    required this.joinCode,
    required this.createdAt,
    this.studentCount = 0,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
    classId: json['class_id'] as int,
    className: json['class_name'] as String,
    subjectName: json['subject_name'] as String?,
    joinCode: json['join_code'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    studentCount: (json['student_count'] ?? 0) as int,
  );

  Map<String, dynamic> toJson() => {
    'class_id': classId,
    'class_name': className,
    'subject_name': subjectName,
    'join_code': joinCode,
    'created_at': createdAt.toIso8601String(),
    'student_count': studentCount,
  };
}

class DashboardStats {
  final int studentCount;
  final int paperCount;
  final int presentToday;
  final int absentToday;
  final bool attendanceTaken;
  final double? avgScore;

  const DashboardStats({
    required this.studentCount,
    required this.paperCount,
    required this.presentToday,
    required this.absentToday,
    required this.attendanceTaken,
    this.avgScore,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    studentCount: (json['student_count'] ?? 0) as int,
    paperCount: (json['paper_count'] ?? 0) as int,
    presentToday: (json['present_today'] ?? 0) as int,
    absentToday: (json['absent_today'] ?? 0) as int,
    attendanceTaken: (json['attendance_taken'] ?? false) as bool,
    avgScore: json['avg_score'] != null
        ? (json['avg_score'] as num).toDouble()
        : null,
  );

  factory DashboardStats.empty() => const DashboardStats(
    studentCount: 0,
    paperCount: 0,
    presentToday: 0,
    absentToday: 0,
    attendanceTaken: false,
  );
}

// ── Service ───────────────────────────────────────────────────

class ClassService {
  // ── CHANGE THIS to your server IP and port ──────────────────
  //    Use your machine's local IP (not localhost) so the
  //    Android emulator / physical device can reach your server.
  //    e.g. "http://192.168.1.10:3000"
  static const String _base =
      'http://10.0.2.2:3000'; // 10.0.2.2 = localhost on Android emulator

  static String get _token => UserSession.token;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  // ── Create class ────────────────────────────────────────────
  static Future<ClassModel> createClass({
    required String className,
    String? subjectName,
  }) async {
    final uri = Uri.parse('$_base/api/classes/create');
    final res = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({'class_name': className, 'subject_name': subjectName}),
    );

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) throw data['message'] ?? 'Failed to create class';
    return ClassModel.fromJson(data['class'] as Map<String, dynamic>);
  }

  // ── Fetch teacher's classes ──────────────────────────────────
  static Future<List<ClassModel>> fetchMyClasses() async {
    final uri = Uri.parse('$_base/api/classes/my-classes');
    final res = await http.get(uri, headers: _headers);

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) throw data['message'] ?? 'Failed to fetch classes';

    final list = data['classes'] as List<dynamic>;
    return list
        .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Fetch dashboard stats for a class ───────────────────────
  static Future<DashboardStats> fetchStats(int classId) async {
    final uri = Uri.parse('$_base/api/classes/$classId/stats');
    final res = await http.get(uri, headers: _headers);

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) throw data['message'] ?? 'Failed to fetch stats';
    return DashboardStats.fromJson(data['stats'] as Map<String, dynamic>);
  }

  // ── Join class (student) ─────────────────────────────────────
  static Future<ClassModel> joinClass(String joinCode) async {
    final uri = Uri.parse('$_base/api/classes/join');
    final res = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({'join_code': joinCode.toUpperCase().trim()}),
    );

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) throw data['message'] ?? 'Failed to join class';
    return ClassModel.fromJson(data['class'] as Map<String, dynamic>);
  }

  // ── Delete class ─────────────────────────────────────────────
  static Future<void> deleteClass(int classId) async {
    final uri = Uri.parse('$_base/api/classes/$classId');
    final res = await http.delete(uri, headers: _headers);

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) throw data['message'] ?? 'Failed to delete class';
  }
}
