// lib/presentation/tasks/widgets/task_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ...existing code...
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import 'add_edit_task_sheet.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final String userId;

  const TaskListItem({super.key, required this.task, required this.userId});

  Color _priorityColor() {
    switch (task.priority) {
      case 'high':
        return AppTheme.highPriority;
      case 'low':
        return AppTheme.lowPriority;
      default:
        return AppTheme.mediumPriority;
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TaskBloc>().add(
                    TaskDelete(userId: userId, taskId: task.id),
                  );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: AddEditTaskSheet(userId: userId, existingTask: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;
    final priorityColor = _priorityColor();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Priority indicator
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),

            // Checkbox
            GestureDetector(
              onTap: () => context.read<TaskBloc>().add(TaskToggleCompletion(task)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDone ? AppTheme.primaryColor : Colors.transparent,
                  border: Border.all(
                    color: isDone ? AppTheme.primaryColor : AppTheme.textHint,
                    width: 1.8,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: isDone
                    ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(width: 12),

            // Title + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                      color: isDone ? AppTheme.textHint : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: DateFormatter.isOverdue(task.dueDate) && !task.isCompleted
                              ? AppTheme.errorColor
                              : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          DateFormatter.formatDate(task.dueDate!),
                          style: TextStyle(
                            fontSize: 11,
                            color: DateFormatter.isOverdue(task.dueDate) && !task.isCompleted
                                ? AppTheme.errorColor
                                : AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Priority badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.priority,
                style: TextStyle(
                  color: priorityColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Edit button
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryColor),
              tooltip: 'Edit',
              onPressed: () => _showEditSheet(context),
            ),

            // Delete button
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.errorColor),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }
}
