// lib/domain/repositories/task_repository.dart
import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks(String userId);
  Future<Task> addTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String userId, String taskId);
  Future<Task> toggleTaskCompletion(Task task);
}
