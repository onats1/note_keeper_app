import 'package:flutter/material.dart';
import 'package:notekeeperapp/models/note.dart';
import 'package:notekeeperapp/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  String title;
  Note note;

  NoteDetail(this.note, this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(note, title);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ["High", "Low"];
  var selectedDropDownValue = "Low";
  var appBarTitle;
  DatabaseHelper helper = DatabaseHelper();
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    // TODO: implement build
    return WillPopScope(

        // ignore: missing_return
        onWillPop: () {
          navigateBack();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                navigateBack();
              },
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: DropdownButton(
                      items: _priorities.map((dropDownItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownItem,
                          child: Text(
                            dropDownItem,
                          ),
                        );
                      }).toList(),
                      style: textStyle,
                      value: convertIntPriorityToString(note.priority),
                      onChanged: (userSelectedValue) {
                        setState(() {
                          selectedDropDownValue = userSelectedValue;
                          updatePriorityAsInt(userSelectedValue);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter title";
                        }
                      },
                      style: textStyle,
                      controller: titleController,
                      onChanged: (value) {
                        note.title = value;
                      },
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        note.description = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a description";
                        }
                      },
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: "Description",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  _save();
                                }
                              });
                              print(
                                  "------------------------------------------------------------------------------------------");
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              deleteNote();
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void navigateBack() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String priority) {
    switch (priority) {
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
      default:
        note.priority = 2;
    }
  }

  String convertIntPriorityToString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void _save() async {
    navigateBack();
    // note.date = DateFormat.yMMMd.format(DateTime.now());
    int result;
    if (note.id != null) {
      try {
        result = await helper.updateNote(this.note);
        print(result.toString());
      } catch (e) {
        print(e);
      }
    } else {
      result = await helper.insertNote(note);
      print(result.toString());
    }

    if (result != 0) {
      displayAlertDialog("Status", "Saved Successfully!");
    } else {
      displayAlertDialog("Status", "Failed to save note.");
    }
    print(
        "------------------------------------------------------------------------------$result------------");
  }

  void deleteNote() async {
    navigateBack();
    if (note.id == null) {
      displayAlertDialog("Status", "No note was deleted");
      return;
    }

    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      displayAlertDialog("Status", "Note was deleted successfully");
    } else {
      displayAlertDialog("Status", "Note could not be deleted");
    }
  }

  void displayAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
