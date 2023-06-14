import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/custom_colors.dart';
import '../models/note.dart';
import '../models/note_data.dart';

import '../ffi.dart';

// ignore: must_be_immutable
class EditingNotePage extends StatefulWidget {
  Note note;
  bool isNewNote;

  EditingNotePage({
    super.key,
    required this.note,
    required this.isNewNote,
  });

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  // add new note
  Future<void> handleNote(String tag, String text) async {
    try {
      final receivedBlockId =
          await api.publishTaggedDataBlock(message: text, tag: tag);

      storeAndReturnToHomepage(tag, text, receivedBlockId);
    } on FfiException catch (e) {
      showSnackBar(e.message);
    }
  }

  void showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void storeAndReturnToHomepage(String tag, String text, String blockId) {
    // add the new note
    Provider.of<NoteData>(context, listen: false).addNewNote(
        Note(id: widget.note.id, tag: tag, text: text, blockId: blockId));
    Navigator.pop(context);
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(
        'https://explorer.shimmer.network/shimmer/block/${widget.note.blockId}');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appleBackground,
      appBar: AppBar(
        title: widget.isNewNote
            ? const Text(
                'Add Tagged Data Block',
                style: TextStyle(color: Colors.black, fontSize: 22),
              )
            : const Text(
                'Info',
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
        elevation: 0,
        //backgroundColor: Colors.transparent,
        backgroundColor: const Color(0xff00e0ca),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                if (widget.isNewNote)
                  FormBuilderTextField(
                    name: 'text',
                    validator: FormBuilderValidators.minLength(4),
                    initialValue: widget.note.text,
                    decoration: const InputDecoration(
                      hintText: 'Insert a new text message',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                if (!widget.isNewNote)
                  FormBuilderTextField(
                    name: 'text',
                    validator: FormBuilderValidators.minLength(4),
                    enabled: false,
                    initialValue: widget.note.text,
                    decoration: const InputDecoration(
                      hintText: 'Insert a new text message',
                      filled: true,
                      fillColor: Colors.white,
                      label: Text('Text'),
                    ),
                  ),
                const SizedBox(height: 20),
                if (widget.isNewNote)
                  FormBuilderTextField(
                    name: 'tag',
                    validator: FormBuilderValidators.minLength(4),
                    initialValue: widget.note.tag,
                    decoration: const InputDecoration(
                      hintText: 'Insert a new tag',
                    ),
                  ),
                if (!widget.isNewNote)
                  FormBuilderTextField(
                    name: 'tag',
                    validator: FormBuilderValidators.minLength(4),
                    enabled: false,
                    initialValue: widget.note.tag,
                    decoration: const InputDecoration(
                      hintText: 'Insert a new tag',
                      label: Text('Tag'),
                    ),
                  ),
                const SizedBox(height: 50),
                if (widget.isNewNote)
                  ElevatedButton(
                    onPressed: () {
                      bool ok = _formKey.currentState!.saveAndValidate();
                      if (ok) {
                        handleNote(_formKey.currentState?.fields['tag']?.value,
                            _formKey.currentState?.fields['text']?.value);
                      }
                      debugPrint(
                          _formKey.currentState?.instantValue.toString() ?? '');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          CustomColors.shimmerGreen, // Background color
                      foregroundColor:
                          Colors.black, // Text Color (Foreground color)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Send to Tangle',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                if (!widget.isNewNote)
                  ElevatedButton(
                    onPressed: () {
                      _launchUrl();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          CustomColors.shimmerGreen, // Background color
                      foregroundColor:
                          Colors.black, // Text Color (Foreground color)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Show in Block Explorer',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
