import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/models/note.dart';
import 'package:uuid/uuid.dart';

import '../models/note_data.dart';
import 'editing_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteData>(context, listen: false).initializeList();
  }

  // create a new note
  void createNewNote() {
    // create a blank note
    var uuid = const Uuid();
    String id = uuid.v4();
    String tag = '';
    String text = '';
    String blockId = '';
    Note newNote = Note(id: id, tag: tag, text: text, blockId: blockId);

    // go to edit the note
    goToNotePage(newNote, true);
  }

  // go to note editing page
  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingNotePage(note: note, isNewNote: isNewNote),
      ),
    );
  }

  // delete note
  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        appBar: AppBar(
          backgroundColor: const Color(0xff00e0ca),
          elevation: 0,
          title: const Text(
            "Simple App",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewNote,
          elevation: 0,
          backgroundColor: const Color(0xff00e0ca),
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //heading
              const Padding(
                padding: EdgeInsets.only(left: 38.0, top: 25),
                child: Text(
                  'My Tagged Data Blocks',
                  style: TextStyle(fontSize: 22),
                ),
              ),

              // list of notes
              value.getAllNotes().isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text(
                          'Nothing here...',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : CupertinoListSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      children: List.generate(
                        value.getAllNotes().length,
                        (index) => CupertinoListTile(
                          title: Text(value.getAllNotes()[index].text),
                          subtitle: Text(value.getAllNotes()[index].tag),
                          //additionalInfo: Text(value.getAllNotes()[index].tag),
                          onTap: () =>
                              goToNotePage(value.getAllNotes()[index], false),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => {
                              goToNotePage(value.getAllNotes()[index], false)
                            },
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
