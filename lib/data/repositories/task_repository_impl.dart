// lib/data/repositories/task_repository_impl.dart
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _dataSource;

  TaskRepositoryImpl({required TaskRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Task>> fetchTasks(String userId) async {
    return await _dataSource.fetchTasks(userId);
  }

  @override
  Future<Task> addTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    return await _dataSource.addTask(model);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    return await _dataSource.updateTask(model);
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    return await _dataSource.deleteTask(userId, taskId);
  }

  @override
  Future<Task> toggleTaskCompletion(Task task) async {
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );
    return await updateTask(updated);
  }
}
