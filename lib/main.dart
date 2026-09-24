import 'package:flutter/material.dart';

import 'segunda_tela.dart';

import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

import 'database/database_helper.dart';

import 'dart:io';

void main() {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          234,
          196,
          196,
        ), // redAccent
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
  final TextEditingController tarefaController =
      TextEditingController(); // Controlador para o campo de texto

  // List<String> tarefas = []; // Lista para armazenar as tarefas

  List<Map<String, dynamic>> tarefas = [];

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final dados = await DatabaseHelper.instance.listarTarefas();
    setState(() {
      tarefas = dados;
    });
  }

  int? indiceEdicao;

  Future<void> adicionarTarefa() async {
    if (tarefaController.text.isEmpty) {
      //SnackBar para informar que a tarefa não pode ser vazia
      return; // Não adiciona tarefas vazias
    }

    await DatabaseHelper.instance.inserirTarefa(tarefaController.text);
    tarefaController.clear(); // Limpa o campo de texto após adicionar a tarefa

    carregarTarefas();
  }

  // void editarTarefa(int index) {
  //   setState(() {
  //     tarefaController.text = tarefas[index];
  //     indiceEdicao = index;
  //   });
  // }

  Future<void> removerTarefa(int index) async {
    await DatabaseHelper.instance.removerTarefa(index);
    carregarTarefas();
  }

  Widget build(BuildContext context) {
    //Método responsável por construir a interface do usuário da página inicial
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Tarefas',
          style: TextStyle(
            color: const Color.fromARGB(255, 15, 14, 14),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: tarefaController,
                    decoration: InputDecoration(
                      hintText: 'Digite uma tarefa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para adicionar a tarefa
                    adicionarTarefa();
                  },
                  child: Text(indiceEdicao == null ? 'Adicionar' : 'Atualizar'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text((tarefas[index]['descricao'])),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Lógica para remover a tarefa
                              removerTarefa(tarefas[index]['id']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // editarTarefa(index);
                            },
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
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SegundaTela()),
                );
              },
              child: const Text('Sobre'),
            ),
          ),
        ],
      ),
    );
  }
}