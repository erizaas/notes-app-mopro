import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContactHome extends StatefulWidget {
  const ContactHome({super.key});

  @override
  State<ContactHome> createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHome> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  late Box _contactsBox;

  @override
  void initState() {
    super.initState();
    _contactsBox = Hive.box('contacts_box');
  }

  // CREATE: Tambah kontak ke Hive Box
  void _addContact() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      _contactsBox.add({
        'name': _nameController.text,
        'phone': _phoneController.text,
      });
      _nameController.clear();
      _phoneController.clear();
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  // DELETE: Hapus kontak dari Hive Box
  void _deleteContact(int index) {
    _contactsBox.deleteAt(index);
    setState(() {});
  }

  // Dialog Form Tambah Kontak
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kontak Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _addContact,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], foregroundColor: Colors.white),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact App (Hive)", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[700],
      ),
      body: ValueListenableBuilder(
        valueListenable: _contactsBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("Belum ada kontak tersimpan."));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final contact = box.getAt(index) as Map;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[700],
                    child: Text(contact['name'][0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(contact['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(contact['phone']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () => _deleteContact(index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}