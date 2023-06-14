import 'package:hive/hive.dart';

import '../models/note.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box('note_database');

  // load notes
  List<Note> loadNotes() {
    List<Note> saveNotesFormatted = [];

    // if there exit notes, return that, otherwise return empty list
    if (_myBox.get("ALL_NOTES") != null) {
      List<dynamic> savedNotes = _myBox.get("ALL_NOTES");
      for (int i = 0; i < savedNotes.length; i++) {
        Note individualNote = Note(
            id: savedNotes[i][0],
            tag: savedNotes[i][1],
            text: savedNotes[i][2],
            blockId: savedNotes[i][3]);
        // add to list
        saveNotesFormatted.add(individualNote);
      }
    }

    return saveNotesFormatted;
  }

  // save notes
  void saveNotes(List<Note> allNotes) {
    List<List<dynamic>> allNotesFormatted = [
      /*
      [
        [ id1, tag1, text1 ],
        [ id2, tag2, text2 ],
      ]
      */
    ];
    // each note has and id, tag, text and blockId
    for (var note in allNotes) {
      allNotesFormatted.add([note.id, note.tag, note.text, note.blockId]);
    }

    // then, store into hive
    _myBox.put("ALL_NOTES", allNotesFormatted);
  }
}
