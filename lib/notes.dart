import 'package:first_sql/sql_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sql_helper.dart';

class notes_App extends StatefulWidget {
  const notes_App({super.key});

  @override
  State<notes_App> createState() => _notes_AppState();
}

class _notes_AppState extends State<notes_App> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: SqlHelper().loadNotes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              SqlHelper().deleteNote(
                                snapshot.data![index]['id'],
                              );
                            },
                            child: Card(
                              color: Colors.purple,
                              child: Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showEditNoteDialog(
                                          context,
                                          snapshot.data![index]['title'],
                                          snapshot.data![index]['content'],
                                          snapshot.data![index]['id']);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  Text(
                                    ('id ${snapshot.data![index]['id']}'),
                                  ),
                                  Text(
                                    (" title : ") +
                                        (snapshot.data![index]['title'])
                                            .toString(),
                                  ),
                                  Text(
                                    (" content : ") +
                                        (snapshot.data![index]['content'])
                                            .toString(),
                                  ),
                                ],
                              ),
                            ));
                      });
                }
                return Center(child: CircularProgressIndicator());
              },
            )),
            Expanded(
                child: FutureBuilder(
              future: SqlHelper().loadToDo(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        bool isdone =
                            snapshot.data![index]['value'] == 0 ? false : true;
                        return Card(
                          color: isdone ? Colors.green : Colors.red,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: isdone,
                                  onChanged: (bool? value) {
                                    SqlHelper()
                                        .updateToDoChecked(
                                            snapshot.data![index]['id'],
                                            snapshot.data![index]['value'])
                                        .whenComplete(() => setState(() {}));
                                  }),
                              Text(
                                ('${snapshot.data![index]['title']}'),
                                style: TextStyle(
                                    color:
                                        isdone ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        );
                      });
                }
                return Center(child: CircularProgressIndicator());
              },
            ))
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'increment',
            onPressed: () {
              showInsertNoteDialog(context);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.purple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FloatingActionButton(
              tooltip: 'increment',
              onPressed: () {
                showInsertTodoDialog(context);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

//note insert dialog
  void showInsertNoteDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return Material(
          color: Colors.white.withOpacity(0.3),
          child: CupertinoAlertDialog(
            title: Text("add new note"),
            content: Column(
              children: [
                TextField(
                  controller: titleController,
                ),
                TextField(
                  controller: contentController,
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: Text("NO"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("YES"),
                onPressed: () {
                  SqlHelper()
                      .insertNote(
                        Note(
                            title: titleController.text,
                            content: contentController.text),
                      )
                      .whenComplete(() => setState(() {}));
                  titleController.clear();
                  contentController.clear();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

//note edit dialog
  void showEditNoteDialog(
      context, String titleInit, String contentInit, int id) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return Material(
          color: Colors.white.withOpacity(0.3),
          child: CupertinoAlertDialog(
            title: Text("edit note"),
            content: Column(
              children: [
                TextFormField(
                  initialValue: titleInit,
                ),
                TextFormField(
                  initialValue: contentInit,
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: Text("NO"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("YES"),
                onPressed: () {
                  SqlHelper()
                      .updateNote(
                        Note(title: titleInit, content: contentInit, id: id),
                      )
                      .whenComplete(() => setState(() {}));
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

//to do insert dialog
  void showInsertTodoDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return Material(
          color: Colors.white.withOpacity(0.3),
          child: CupertinoAlertDialog(
            title: Text("add new To Do"),
            content: Column(
              children: [
                TextField(
                  controller: titleController,
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: Text("NO"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("YES"),
                onPressed: () {
                  SqlHelper()
                      .insertToDo(
                        TODO(
                          title: titleController.text,
                        ),
                      )
                      .whenComplete(() => setState(() {}));
                  titleController.clear();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
