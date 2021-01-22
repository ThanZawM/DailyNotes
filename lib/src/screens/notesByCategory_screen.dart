import 'package:DailyNotes/src/models/note.dart';
import 'package:DailyNotes/src/services.dart/note_actions.dart';
import 'package:flutter/material.dart';

class NotesByCategory extends StatefulWidget {
  NotesByCategory({this.title});
  final String title;
  @override
  _NotesByCategoryState createState() => _NotesByCategoryState();
}

class _NotesByCategoryState extends State<NotesByCategory> {
  var _noteList = List<Note>();

  var _noteActions = NoteActions();

  getNotesByCategory() async {
    var notes = await _noteActions.readNoteByCategory(this.widget.title);
    notes.forEach((cat) {
      setState(() {
        var modelNote = Note();
        modelNote.title = cat['title'];
        modelNote.description = cat['description'];
        modelNote.date = cat['date'];
        _noteList.add(modelNote);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNotesByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.title),
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => MyHomePage()));
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_noteList[index].title ?? 'No Title'),
                          ],
                        ),
                        subtitle: Text(
                            _noteList[index].description ?? 'No Description'),
                        trailing: Text(_noteList[index].date ?? 'No Date'),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
