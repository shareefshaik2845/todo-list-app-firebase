// lib/domain/entities/task.dart
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final bool isCompleted;
  final String priority; // high | medium | low
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = 'medium',
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isCompleted,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearDueDate = false,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, title, description, isCompleted,
        priority, dueDate, createdAt, updatedAt,
      ];
}
