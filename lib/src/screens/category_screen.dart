import 'package:DailyNotes/src/services.dart/category_actions.dart';
import 'package:flutter/material.dart';
import 'package:DailyNotes/src/models/category.dart';
import 'package:DailyNotes/src/screens/home_page.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _categoryNameController = TextEditingController();
  final _categoryDescriptionController = TextEditingController();

  final _editCategoryNameController = TextEditingController();
  final _editCategoryDescriptionController = TextEditingController();

  final _category = Categories();
  final _categoryActions = CategoryActions();
  List<Categories> _categoryList = List<Categories>();
  var category;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Categories>();
    var categories = await _categoryActions.readCategory();
    categories.forEach((cat) {
      setState(() {
        var categoryModel = Categories();
        categoryModel.id = cat['id'];
        categoryModel.name = cat['name'];
        categoryModel.description = cat['description'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _showFormDialog(BuildContext context) async {
    return showDialog(
      context: context,
      //barrierColor: Colors.red[200],
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Category Form'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL')),
            FlatButton(
                onPressed: () async {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  var result = await _categoryActions.saveCategory(_category);
                  if (result > 0) {
                    print(result);
                    Navigator.of(context).pop();
                    getAllCategories();
                    _globalKey.currentState.showSnackBar(SnackBar(
                      content: Text('Inserted!'),
                      backgroundColor: Colors.pinkAccent,
                    ));
                  }

                  _categoryNameController.text = "";
                  _categoryDescriptionController.text = "";
                },
                child: Text('SAVE')),
          ],
        );
      },
    );
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryActions.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _editFormDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Category Form'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _editCategoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _editCategoryDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL')),
            FlatButton(
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  var result = await _categoryActions.updateCategory(_category);
                  if (result > 0) {
                    //print(result);
                    Navigator.of(context).pop();
                    getAllCategories();
                    _globalKey.currentState.showSnackBar(SnackBar(
                      content: Text('Updated!'),
                      backgroundColor: Colors.pinkAccent,
                    ));
                  }

                  //_editCategoryNameController.text = "";
                  //_editCategoryDescriptionController.text = "";
                },
                child: Text('UPDATE')),
          ],
        );
      },
    );
  }

  _deleteFormDialog(BuildContext context, categoryId) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          content: Text('Are you sure you want to delete?'),
          actions: [
            FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL')),
            FlatButton(
                color: Colors.red,
                onPressed: () async {
                  var result =
                      await _categoryActions.deleteCategoryById(categoryId);
                  if (result > 0) {
                    //print(result);
                    Navigator.of(context).pop();
                    getAllCategories();
                    _globalKey.currentState.showSnackBar(SnackBar(
                      content: Text('Deleted!'),
                      backgroundColor: Colors.pinkAccent,
                    ));
                  }
                },
                child: Text('OK')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Category'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Card(
              elevation: 8.0, //shadow
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editCategory(context, _categoryList[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_categoryList[index].name),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _deleteFormDialog(context, _categoryList[index].id);
                        })
                  ],
                ),
                //subtitle: Text(_categoryList[index].description),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Category',
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
