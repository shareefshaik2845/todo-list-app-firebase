// lib/presentation/tasks/pages/tasks_page.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/add_edit_task_sheet.dart';
import '../widgets/task_filter_chip.dart';
import '../widgets/task_list_item.dart';
import '../widgets/tasks_header.dart';

class TasksPage extends StatefulWidget {
  final UserEntity user;
  const TasksPage({super.key, required this.user});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(TaskFetchAll(widget.user.uid));
  }

  bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width > 600;

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: AddEditTaskSheet(userId: widget.user.uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                  backgroundImage: widget.user.photoUrl != null
                      ? NetworkImage(widget.user.photoUrl!)
                      : null,
                  child: widget.user.photoUrl == null
                      ? Text(
                          widget.user.displayName[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.read<AuthBloc>().add(const AuthSignOut());
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout_rounded, color: AppTheme.errorColor),
                          SizedBox(width: 10),
                          Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        elevation: 2,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: largeScreen ? 700 : double.infinity),
            padding: EdgeInsets.symmetric(horizontal: largeScreen ? 32 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Text(
                    'Hello, ${widget.user.displayName.split(' ').first} 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Text(
                    'Here are your tasks',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TasksHeader(),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: TaskFilterChips(),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: BlocConsumer<TaskBloc, TaskState>(
                    listener: (context, state) {
                      if (state is TaskOperationSuccess) {
                        Fluttertoast.showToast(
                          msg: state.message,
                          backgroundColor: AppTheme.successColor,
                          textColor: Colors.white,
                        );
                      } else if (state is TaskError) {
                        Fluttertoast.showToast(
                          msg: state.message,
                          backgroundColor: AppTheme.errorColor,
                          textColor: Colors.white,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is TaskLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppTheme.primaryColor),
                        );
                      }
                      List tasks = [];
                      if (state is TaskLoaded) tasks = state.filteredTasks;
                      if (state is TaskOperationSuccess) {
                        tasks = state.filteredTasks;
                      }
                      if (tasks.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemCount: tasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return FadeInUp(
                            duration: const Duration(milliseconds: 300),
                            delay: Duration(milliseconds: index * 50),
                            child: TaskListItem(
                              task: task,
                              userId: widget.user.uid,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        child: const Icon(Icons.add_rounded),
        tooltip: 'Add Task',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: FadeIn(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No tasks yet!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to add your first task',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
