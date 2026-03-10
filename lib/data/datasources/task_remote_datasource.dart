// lib/data/datasources/task_remote_datasource.dart
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> fetchTasks(String userId);
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String userId, String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client _client;
  final FirebaseAuth _firebaseAuth;

  TaskRemoteDataSourceImpl({
    required http.Client client,
    required FirebaseAuth firebaseAuth,
  })  : _client = client,
        _firebaseAuth = firebaseAuth;

  String get _baseUrl => AppConstants.firebaseDbBaseUrl;

  /// Get the current Firebase ID token for authenticated REST calls
  Future<String?> _getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  String _tasksUrl(String userId) =>
      '$_baseUrl/${AppConstants.tasksNode}/$userId.json';

  String _taskUrl(String userId, String taskId) =>
      '$_baseUrl/${AppConstants.tasksNode}/$userId/$taskId.json';

  @override
  Future<List<TaskModel>> fetchTasks(String userId) async {
    final token = await _getIdToken();
    final url = Uri.parse('${_tasksUrl(userId)}?auth=$token');

    final response = await _client.get(url);
    _checkResponse(response);

    final body = json.decode(response.body);
    if (body == null) return [];

    final Map<String, dynamic> data = body as Map<String, dynamic>;
    return data.entries
        .map((e) => TaskModel.fromJson(e.key, e.value as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    final token = await _getIdToken();
    final url = Uri.parse('${_tasksUrl(task.userId)}?auth=$token');

    final response = await _client.post(
      url,
      body: json.encode(task.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    _checkResponse(response);

    final data = json.decode(response.body) as Map<String, dynamic>;
    final newId = data['name'] as String;

    // Fetch the created task to return it with the server-generated ID
    return TaskModel.fromJson(newId, task.toJson());
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final token = await _getIdToken();
    final url = Uri.parse('${_taskUrl(task.userId, task.id)}?auth=$token');

    final response = await _client.put(
      url,
      body: json.encode(task.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    _checkResponse(response);

    return task;
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    final token = await _getIdToken();
    final url = Uri.parse('${_taskUrl(userId, taskId)}?auth=$token');

    final response = await _client.delete(url);
    _checkResponse(response);
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'HTTP Error ${response.statusCode}: ${response.body}');
    }
  }
}
