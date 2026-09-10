import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 180, 105, 44),
      ),
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,

      home: const HomePage(),
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
  final List<String> _tasks = [];
  final Set<int> _selectedIndexes = {};

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final task = _taskController.text.trim();
    if (task.isEmpty) {
      return;
    }

    setState(() {
      _tasks.add(task);
      _taskController.clear();
    });
  }

  void _removeTask(int index) {
    final remainingSelectedIndexes = _selectedIndexes
        .where((selectedIndex) => selectedIndex != index)
        .map(
          (selectedIndex) =>
              selectedIndex > index ? selectedIndex - 1 : selectedIndex,
        )
        .toSet();

    setState(() {
      _tasks.removeAt(index);
      _selectedIndexes
        ..clear()
        ..addAll(remainingSelectedIndexes);
    });
  }

  void _deleteSelectedTasks() {
    final indexes = _selectedIndexes.toList()
      ..sort((first, second) => second.compareTo(first));

    setState(() {
      for (final index in indexes) {
        _tasks.removeAt(index);
      }
      _selectedIndexes.clear();
    });
  }

  void _toggleTaskSelection(int index, bool selected) {
    setState(() {
      if (selected) {
        _selectedIndexes.add(index);
      } else {
        _selectedIndexes.remove(index);
      }
    });
  }

  Future<void> _editTask(int index) async {
    final controller = TextEditingController(text: _tasks[index]);
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

    final task = editedTask?.trim();
    if (task == null || task.isEmpty) {
      return;
    }

    setState(() {
      _tasks[index] = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Método responsável por construir a interface do usuário da página inicial.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndexes.isEmpty
              ? 'Lista de Tarefas'
              : '${_selectedIndexes.length} selecionada(s)',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedIndexes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Excluir tarefas selecionadas',
              onPressed: _deleteSelectedTasks,
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
            SizedBox(height: 16.0),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('Nenhuma tarefa adicionada'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _selectedIndexes.contains(index),
                                  onChanged: (selected) =>
                                      _toggleTaskSelection(index, selected!),
                                ),
                                CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                              ],
                            ),
                            title: Text(_tasks[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Editar tarefa',
                                  onPressed: () => _editTask(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Remover tarefa',
                                  onPressed: () => _removeTask(index),
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
}
