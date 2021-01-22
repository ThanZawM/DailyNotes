import 'package:DailyNotes/src/models/note.dart';
import 'package:DailyNotes/src/screens/category_screen.dart';
import 'package:DailyNotes/src/screens/notesByCategory_screen.dart';
import 'package:DailyNotes/src/screens/notes_screen.dart';
import 'package:DailyNotes/src/services.dart/category_actions.dart';
import 'package:DailyNotes/src/services.dart/note_actions.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Daily Notes';

  NoteActions _noteActions;

  List<Note> _noteList = List<Note>();

  getAllNotes() async {
    _noteActions = NoteActions();
    _noteList = List<Note>();
    var notes = await _noteActions.readNotes();
    notes.forEach((element) {
      setState(() {
        var noteModal = Note();
        noteModal.id = element['id'];
        noteModal.title = element['title'];
        noteModal.description = element['description'];
        noteModal.date = element['date'];
        noteModal.category = element['category'];
        noteModal.isFinished = element['isFinished'];
        _noteList.add(noteModal);
      });
    });
  }

  CategoryActions _categoryActions;
  List<Widget> _categoryList = List<Widget>();

  getAllCategories() async {
    _categoryActions = CategoryActions();
    _categoryList = List<Widget>();
    var categories = await _categoryActions.readCategory();
    categories.forEach((cat) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotesByCategory(
                          title: cat['name'],
                        )));
          },
          child: ListTile(
            title: Text(cat['name']),
          ),
        ));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllNotes();
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                    child: Icon(
                  Icons.person,
                  size: 40,
                )),
                accountName: Text('Than Zaw Myint'),
                accountEmail: Text('thanzawmyint@gmail.com')),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Category'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CategoryScreen()));
              },
            ),
            Divider(
              color: Colors.grey[350],
              thickness: 0.5,
            ),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
      body: ListView.builder(
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
                  subtitle:
                      Text(_noteList[index].description ?? 'No Description'),
                  trailing: Text(_noteList[index].date ?? 'No Date'),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NoteScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
