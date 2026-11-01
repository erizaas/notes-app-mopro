import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' hide context;
import 'package:flutter/foundation.dart'; // Untuk mendeteksi kIsWeb
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Jembatan khusus web

class SqfliteHome extends StatefulWidget {
  const SqfliteHome({super.key});

  @override
  State<SqfliteHome> createState() => _SqfliteHomeState();
}

class _SqfliteHomeState extends State<SqfliteHome> {
  Database? _database;
  List _tasks = []; 
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    if (kIsWeb) {
      // KONFIGURASI KHUSUS CHROME / WEB
      var factory = databaseFactoryFfiWeb;
      _database = await factory.openDatabase(
        'tasks.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT
              )
            ''');
          },
        ),
      );
    } else {
      // KONFIGURASI ASLI BUAT MAC / ANDROID / IOS
      final dbPath = await getDatabasesPath();
      final dbPathJoined = join(dbPath, 'tasks.db');

      _database = await openDatabase(
        dbPathJoined,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT
            )
          ''');
        },
      );
    }
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await _database?.query('tasks', orderBy: 'id DESC');
    setState(() {
      _tasks = data ?? [];
    });
  }

  Future<void> _addTask(String title) async {
    if (title.isNotEmpty) {
      await _database?.insert('tasks', {'title': title});
      _taskController.clear();
      _loadTasks();
    }
  }

  Future<void> _updateTask(int id, String currentTitle) async {
    _taskController.text = currentTitle;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tugas'),
        content: TextField(controller: _taskController),
        actions: [
          TextButton(
            onPressed: () {
              _taskController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _database?.update(
                'tasks',
                {'title': _taskController.text},
                where: 'id = ?',
                whereArgs: [id],
              );
              _taskController.clear();
              _loadTasks();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], foregroundColor: Colors.white),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(int id) async {
    await _database?.delete('tasks', where: 'id = ?', whereArgs: [id]);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task App (SQFlite)", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'Tambah Tugas Baru',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addTask(_taskController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(task['title']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _updateTask(task['id'], task['title']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(task['id']),
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
    );
  }
}