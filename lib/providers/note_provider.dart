import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';

enum ViewState { loading, loaded, empty, error }

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  ViewState _state = ViewState.loading;
  String _errorMessage = '';

  List<Note> get notes => _notes;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  // Load / Fetch Data
  Future<void> fetchNotes() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _notes = await DatabaseHelper.instance.readAllNotes();
      if (_notes.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.loaded;
      }
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = 'Gagal memuat data: ${e.toString()}';
    }
    notifyListeners();
  }

  // Add Data
  Future<void> addNote(String title, String content) async {
    try {
      final newNote = Note(title: title, content: content);
      await DatabaseHelper.instance.insert(newNote);
      await fetchNotes();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = 'Gagal menambah data';
      notifyListeners();
    }
  }

  // Update Data
  Future<void> updateNote(int id, String title, String content) async {
    try {
      final updatedNote = Note(id: id, title: title, content: content);
      await DatabaseHelper.instance.update(updatedNote);
      await fetchNotes();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = 'Gagal mengubah data';
      notifyListeners();
    }
  }

  // Delete Data
  Future<void> deleteNote(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);
      await fetchNotes();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = 'Gagal menghapus data';
      notifyListeners();
    }
  }
}