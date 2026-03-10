// lib/presentation/tasks/bloc/task_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';
import 'task_event.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final TaskFilter currentFilter;

  const TaskLoaded({
    required this.allTasks,
    required this.filteredTasks,
    this.currentFilter = TaskFilter.all,
  });

  int get totalCount => allTasks.length;
  int get completedCount => allTasks.where((t) => t.isCompleted).length;
  int get activeCount => allTasks.where((t) => !t.isCompleted).length;

  TaskLoaded copyWith({
    List<Task>? allTasks,
    List<Task>? filteredTasks,
    TaskFilter? currentFilter,
  }) {
    return TaskLoaded(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [allTasks, filteredTasks, currentFilter];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskOperationSuccess extends TaskState {
  final String message;
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final TaskFilter currentFilter;

  const TaskOperationSuccess({
    required this.message,
    required this.allTasks,
    required this.filteredTasks,
    this.currentFilter = TaskFilter.all,
  });

  @override
  List<Object?> get props => [message, allTasks, filteredTasks, currentFilter];
}
