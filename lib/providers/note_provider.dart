import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = await DatabaseHelper.instance.getAllNotes();
    _isLoading = false;
    notifyListeners();
  }

  // Parameter diubah agar menerima objek Note
  Future<void> addNote(Note note) async {
    await DatabaseHelper.instance.insertNote(note);
    await fetchNotes();
  }

  // Parameter diubah agar menerima objek Note
  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.updateNote(note);
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    await fetchNotes();
  }
}