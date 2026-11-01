import 'package:flutter/material.dart';
import 'notes_app/notes_home.dart';
import 'contact_app/contact_home.dart';
import '../sqflite_app/sqflite_home.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: const Text(
          "Main App - Local Storage Praktikum",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Notes App", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Storage: shared_preferences"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotesHome())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], foregroundColor: Colors.white),
                child: const Text("Buka Notes App"),
              ),
              const SizedBox(height: 30),

              const Text("Contact App", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Storage: Hive (NoSQL Alternative)"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContactHome())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], foregroundColor: Colors.white),
                child: const Text("Buka Contact App"),
              ),
              const SizedBox(height: 30),

              const Text("Task App", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Storage: SQFlite (Relational Database)"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SqfliteHome())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], foregroundColor: Colors.white),
                child: const Text("Buka Task App"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}