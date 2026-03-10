// lib/presentation/tasks/bloc/task_event.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskFetchAll extends TaskEvent {
  final String userId;
  const TaskFetchAll(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TaskAdd extends TaskEvent {
  final Task task;
  const TaskAdd(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdate extends TaskEvent {
  final Task task;
  const TaskUpdate(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDelete extends TaskEvent {
  final String userId;
  final String taskId;
  const TaskDelete({required this.userId, required this.taskId});

  @override
  List<Object?> get props => [userId, taskId];
}

class TaskToggleCompletion extends TaskEvent {
  final Task task;
  const TaskToggleCompletion(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskFilterChanged extends TaskEvent {
  final TaskFilter filter;
  const TaskFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

enum TaskFilter { all, active, completed }
