import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import 'note_form_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<NoteProvider>(context, listen: false).fetchNotes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Catatan'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          // 1. Tampilan Loading
          if (provider.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Tampilan Error
          if (provider.state == ViewState.error) {
            return Center(
              child: Text(
                provider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 3. Tampilan Data Kosong
          if (provider.state == ViewState.empty) {
            return const Center(
              child: Text('Belum ada catatan. Tambahkan sekarang!'),
            );
          }

          // 4. Tampilan Data Terisi
          return ListView.builder(
            itemCount: provider.notes.length,
            itemBuilder: (context, index) {
              final note = provider.notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteNote(note.id!);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteFormPage(note: note),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}