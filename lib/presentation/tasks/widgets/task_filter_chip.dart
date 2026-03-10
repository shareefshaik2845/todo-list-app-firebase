// lib/presentation/tasks/widgets/task_filter_chip.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        TaskFilter current = TaskFilter.all;
        if (state is TaskLoaded) current = state.currentFilter;
        if (state is TaskOperationSuccess) current = state.currentFilter;

        return Row(
          children: [
            _FilterChip(
              label: 'All',
              filter: TaskFilter.all,
              current: current,
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Active',
              filter: TaskFilter.active,
              current: current,
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Completed',
              filter: TaskFilter.completed,
              current: current,
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final TaskFilter filter;
  final TaskFilter current;

  const _FilterChip({
    required this.label,
    required this.filter,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = filter == current;
    return GestureDetector(
      onTap: () =>
          context.read<TaskBloc>().add(TaskFilterChanged(filter)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.primaryColor,
            fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
