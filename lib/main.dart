import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

enum TaskFilter { all, active, completed }

class TaskItem {
  TaskItem({
    required this.id,
    required this.text,
    this.completed = false,
  });

  final String id;
  final String text;
  final bool completed;

  TaskItem copyWith({String? text, bool? completed}) {
    return TaskItem(
      id: id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  final List<TaskItem> _tasks = [];
  final Set<String> _selectedTaskIds = {};
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  List<TaskItem> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.completed).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.completed).toList();
      case TaskFilter.all:
      default:
        return _tasks;
    }
  }

  void _addTask() {
    final taskText = _taskController.text.trim();
    if (taskText.isEmpty) {
      return;
    }

    setState(() {
      _tasks.add(
        TaskItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: taskText,
        ),
      );
      _taskController.clear();
    });
  }

  void _removeTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
      _selectedTaskIds.remove(taskId);
    });
  }

  void _deleteSelectedTasks() {
    setState(() {
      for (final taskId in _selectedTaskIds) {
        _tasks.removeWhere((task) => task.id == taskId);
      }
      _selectedTaskIds.clear();
    });
  }

  void _toggleTaskSelection(String taskId, bool selected) {
    setState(() {
      if (selected) {
        _selectedTaskIds.add(taskId);
      } else {
        _selectedTaskIds.remove(taskId);
      }
    });
  }

  void _toggleTaskCompletion(TaskItem task) {
    setState(() {
      final index = _tasks.indexWhere((item) => item.id == task.id);
      if (index == -1) {
        return;
      }

      _tasks[index] = _tasks[index].copyWith(
        completed: !task.completed,
      );
    });
  }

  Future<void> _editTask(TaskItem task) async {
    final controller = TextEditingController(text: task.text);
    final editedTask = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarefa'),
          content: TextField(
            controller: controller,
            autofocus: true,
            onSubmitted: (_) => Navigator.of(context).pop(controller.text),
            decoration: const InputDecoration(
              labelText: 'Tarefa',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    final newText = editedTask?.trim();
    if (newText == null || newText.isEmpty) {
      return;
    }

    setState(() {
      final index = _tasks.indexWhere((item) => item.id == task.id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(text: newText);
      }
    });
  }

  String _emptyMessage() {
    switch (_currentFilter) {
      case TaskFilter.active:
        return 'Nenhuma tarefa ativa';
      case TaskFilter.completed:
        return 'Nenhuma tarefa concluída';
      case TaskFilter.all:
      default:
        return 'Nenhuma tarefa adicionada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedTaskIds.isEmpty
              ? 'Lista de Tarefas'
              : '${_selectedTaskIds.length} selecionada(s)',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedTaskIds.isNotEmpty)
            IconButton(
              onPressed: _deleteSelectedTasks,
              icon: const Icon(Icons.delete),
              tooltip: 'Excluir tarefas selecionadas',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    onSubmitted: (_) => _addTask(),
                    decoration: InputDecoration(
                      hintText: 'Digite uma tarefa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                _buildFilterChip('Todas', TaskFilter.all),
                const SizedBox(width: 8),
                _buildFilterChip('Ativas', TaskFilter.active),
                const SizedBox(width: 8),
                _buildFilterChip('Concluídas', TaskFilter.completed),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(child: Text(_emptyMessage()))
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final isSelected = _selectedTaskIds.contains(task.id);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: Checkbox(
                              value: isSelected,
                              onChanged: (selected) =>
                                  _toggleTaskSelection(task.id, selected ?? false),
                            ),
                            title: Text(
                              task.text,
                              style: TextStyle(
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.completed ? Colors.grey : Colors.black,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _toggleTaskCompletion(task),
                                  icon: Icon(
                                    task.completed
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                  ),
                                  tooltip: task.completed
                                      ? 'Marcar como ativa'
                                      : 'Marcar como concluída',
                                ),
                                IconButton(
                                  onPressed: () => _editTask(task),
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Editar tarefa',
                                ),
                                IconButton(
                                  onPressed: () => _removeTask(task.id),
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Remover tarefa',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;

    return Expanded(
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _currentFilter = filter;
          });
        },
      ),
    );
  }
}
