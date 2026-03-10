// lib/presentation/tasks/bloc/task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;
  final Uuid _uuid = const Uuid();

  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskInitial()) {
    on<TaskFetchAll>(_onFetchAll);
    on<TaskAdd>(_onAddTask);
    on<TaskUpdate>(_onUpdateTask);
    on<TaskDelete>(_onDeleteTask);
    on<TaskToggleCompletion>(_onToggleCompletion);
    on<TaskFilterChanged>(_onFilterChanged);
  }

  List<Task> _applyFilter(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.active:
        return tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.all:
      default:
        return List.from(tasks);
    }
  }

  Future<void> _onFetchAll(TaskFetchAll event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    try {
      final tasks = await _taskRepository.fetchTasks(event.userId);
      emit(TaskLoaded(
        allTasks: tasks,
        filteredTasks: tasks,
        currentFilter: TaskFilter.all,
      ));
    } catch (e) {
      emit(TaskError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onAddTask(TaskAdd event, Emitter<TaskState> emit) async {
    final currentState = state;
    List<Task> currentTasks = [];
    TaskFilter currentFilter = TaskFilter.all;

    if (currentState is TaskLoaded) {
      currentTasks = currentState.allTasks;
      currentFilter = currentState.currentFilter;
    }

    try {
      // Assign a temp UUID; server will replace it with Firebase key
      final tempTask = event.task.id.isEmpty
          ? event.task.copyWith(id: _uuid.v4())
          : event.task;

      final addedTask = await _taskRepository.addTask(tempTask);
      final updatedTasks = [addedTask, ...currentTasks];

      emit(TaskOperationSuccess(
        message: 'Task added successfully!',
        allTasks: updatedTasks,
        filteredTasks: _applyFilter(updatedTasks, currentFilter),
        currentFilter: currentFilter,
      ));
    } catch (e) {
      emit(TaskError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateTask(TaskUpdate event, Emitter<TaskState> emit) async {
    final currentState = state;
    List<Task> currentTasks = [];
    TaskFilter currentFilter = TaskFilter.all;

    if (currentState is TaskLoaded) {
      currentTasks = currentState.allTasks;
      currentFilter = currentState.currentFilter;
    } else if (currentState is TaskOperationSuccess) {
      currentTasks = currentState.allTasks;
      currentFilter = currentState.currentFilter;
    }

    try {
      final updatedTask = event.task.copyWith(updatedAt: DateTime.now());
      await _taskRepository.updateTask(updatedTask);

      final updatedTasks = currentTasks.map((t) {
        return t.id == updatedTask.id ? updatedTask : t;
      }).toList();

      emit(TaskOperationSuccess(
        message: 'Task updated successfully!',
        allTasks: updatedTasks,
        filteredTasks: _applyFilter(updatedTasks, currentFilter),
        currentFilter: currentFilter,
      ));
    } catch (e) {
      emit(TaskError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onDeleteTask(TaskDelete event, Emitter<TaskState> emit) async {
    final currentState = state;
    List<Task> currentTasks = [];
    TaskFilter currentFilter = TaskFilter.all;

    if (currentState is TaskLoaded) {
      currentTasks = currentState.allTasks;
      currentFilter = currentState.currentFilter;
    } else if (currentState is TaskOperationSuccess) {
      currentTasks = currentState.allTasks;
      currentFilter = currentState.currentFilter;
    }

    try {
      await _taskRepository.deleteTask(event.userId, event.taskId);
      final updatedTasks = currentTasks.where((t) => t.id != event.taskId).toList();

      emit(TaskOperationSuccess(
        message: 'Task deleted!',
        allTasks: updatedTasks,
        filteredTasks: _applyFilter(updatedTasks, currentFilter),
        currentFilter: currentFilter,
      ));
    } catch (e) {
      emit(TaskError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onToggleCompletion(
      TaskToggleCompletion event, Emitter<TaskState> emit) async {
    final currentState = state;
    List<Task> currentTasks = [];
    TaskFilter currentFilter = TaskFilter.all;

    if (currentState is TaskLoaded) {
      currentTasks = currentState.allTasks;
      currentFilter = currentState.currentFilter;
    } else if (currentState is TaskOperationSuccess) {
      currentTasks = currentState.allTasks;
      currentFilter = currentState.currentFilter;
    }

    // Optimistic update
    final toggled = event.task.copyWith(
      isCompleted: !event.task.isCompleted,
      updatedAt: DateTime.now(),
    );
    final optimisticTasks = currentTasks.map((t) {
      return t.id == toggled.id ? toggled : t;
    }).toList();

    emit(TaskLoaded(
      allTasks: optimisticTasks,
      filteredTasks: _applyFilter(optimisticTasks, currentFilter),
      currentFilter: currentFilter,
    ));

    try {
      await _taskRepository.toggleTaskCompletion(event.task);
    } catch (e) {
      // Revert on error
      emit(TaskLoaded(
        allTasks: currentTasks,
        filteredTasks: _applyFilter(currentTasks, currentFilter),
        currentFilter: currentFilter,
      ));
    }
  }

  void _onFilterChanged(TaskFilterChanged event, Emitter<TaskState> emit) {
    final currentState = state;
    List<Task> allTasks = [];

    if (currentState is TaskLoaded) {
      allTasks = currentState.allTasks;
    } else if (currentState is TaskOperationSuccess) {
      allTasks = currentState.allTasks;
    }

    emit(TaskLoaded(
      allTasks: allTasks,
      filteredTasks: _applyFilter(allTasks, event.filter),
      currentFilter: event.filter,
    ));
  }
}
