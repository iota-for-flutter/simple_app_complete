import 'package:flutter/material.dart';

import '../data/hive_database.dart';
import 'note.dart';

class NoteData extends ChangeNotifier {
  // hive database
  final db = HiveDatabase();

  // overall list of notes
  List<Note> allNotes = [
    //default first note
    // Note(
    //     id: 'abc',
    //     tag: 'First Tag',
    //     text: 'First Note lorem ipsum dolor continua et sufficum ad dolores'),
    // Note(id: 'def', tag: 'Second Tag', text: 'Second Note'),
  ];

  //initialize list
  void initializeList() {
    allNotes = db.loadNotes();
  }

  // get notes
  List<Note> getAllNotes() {
    return allNotes;
  }

  // add a new note
  void addNewNote(Note note) {
    allNotes.add(note);
    db.saveNotes(allNotes);
    notifyListeners();
  }

  //update note
  void updateNote(Note note, String tag, String text) {
    // go thru list of all notes
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        allNotes[i].tag = tag;
        allNotes[i].text = text;
      }
    }
    db.saveNotes(allNotes);
    notifyListeners();
  }

  // delete note
  void deleteNote(Note note) {
    allNotes.remove(note);
    db.saveNotes(allNotes);
    notifyListeners();
  }
}
