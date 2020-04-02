import 'package:flutter/material.dart';
import 'package:notekeeperapp/screens/note_detail.dart';
import 'package:notekeeperapp/models/note.dart';
import 'package:notekeeperapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Fab clicked");
          navigateToDetail(Note("", "", 2), "New Note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(getDescription(position)),
            trailing: GestureDetector(
                onTap: () {
                  deleteNote(context, noteList[position]);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                )),
            onTap: () {
              print("Item selected!");
              navigateToDetail(this.noteList[position], "Edit Note");
            },
          ),
        );
      },
    );
  }

  String getDescription(int position){
    if (this.noteList[position].description == null){
      return "No description";
    }
    else {
      return this.noteList[position].description;
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.arrow_right);
        break;
      default:
        return Icon(Icons.arrow_right);
    }
  }

  void deleteNote(BuildContext context, Note note) async {
    var intValue = databaseHelper.deleteNote(note.id);
    if (intValue != 0) {
      _showSnackBar(context, "Note deleted successfully");
      updateListView();
    }
  }

  void navigateToDetail(Note note, String title) async {

    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true){
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String s) {
    var snackBar = SnackBar(
      content: Text(s),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> futureDb = databaseHelper.initializeDatabase();
    futureDb.then((database) {
      Future<List<Note>> notesList = databaseHelper.getAllNotes();
      notesList.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
