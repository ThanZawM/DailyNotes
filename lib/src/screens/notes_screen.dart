import 'package:DailyNotes/src/models/note.dart';
import 'package:DailyNotes/src/services.dart/category_actions.dart';
import 'package:DailyNotes/src/screens/home_page.dart';
import 'package:DailyNotes/src/services.dart/note_actions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:path/path.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _dateController = TextEditingController();
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _loadCategories() async {
    var _categoryActions = CategoryActions();
    var catagories = await _categoryActions.readCategory();
    catagories.forEach((cat) {
      setState(() {
        _categories.add(
            DropdownMenuItem(value: cat['name'], child: Text(cat['name'])));
      });
    });
  }

  DateTime _dateTime = DateTime.now();
  _selectDate(BuildContext context) async {
    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_pickDate != null) {
      setState(() {
        _dateTime = _pickDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_dateTime);
      });
    }
  }

  _showSuccessSnackbar(message) async {
    _globalKey.currentState.showSnackBar(SnackBar(
      content: message,
      backgroundColor: Colors.yellow,
    ));
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Notes'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyHomePage()));
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description',
              ),
            ),
            TextField(
              showCursor: false,
              keyboardType: TextInputType.datetime,
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a date',
                prefixIcon: InkWell(
                  child: Icon(Icons.date_range),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
              ),
            ),
            DropdownButtonFormField(
              hint: Text('Select a category'),
              value: _selectedValue,
              items: _categories,
              onChanged: (value) {
                _selectedValue = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                var noteObject = Note();
                var noteActions = NoteActions();

                noteObject.title = _titleController.text;
                noteObject.description = _descriptionController.text;
                noteObject.date = _dateController.text;
                noteObject.category = _selectedValue.toString();
                noteObject.isFinished = 0;

                var result = await noteActions.saveNotes(noteObject);
                if (result > 0) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                  _showSuccessSnackbar(Text(
                    'Inserted!',
                    style: TextStyle(color: Colors.black),
                  ));
                }
              },
              color: Colors.blue,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
