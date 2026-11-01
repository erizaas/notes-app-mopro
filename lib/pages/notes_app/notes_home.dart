import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final TextEditingController _noteController = TextEditingController();
  String _savedNote = "Belum ada catatan";

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _saveNote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_note', _noteController.text);
    _loadNote();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan berhasil disimpan!')),
    );
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedNote = prefs.getString('saved_note') ?? "Belum ada catatan";
    });
  }

  Future<void> _deleteNote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_note');
    _noteController.clear();
    _loadNote();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App (Shared Preferences)", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Tulis Catatan Kamu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], foregroundColor: Colors.white),
                  child: const Text('Simpan'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _deleteNote,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white),
                  child: const Text('Hapus'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Catatan Tersimpan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_savedNote, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}