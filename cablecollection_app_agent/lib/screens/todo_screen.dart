import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({Key key}) : super(key: key);

  static const routeName = '/ToDoScreen';

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _selectdate;

  var myFormatData = DateFormat('yyyy-MM-dd');
  List todoData = [];
  var isloading = true;
  var tuId;
  var title = '';
  var description = '';

  Map<String, String> todo = {
    'title': '',
    'description': '',
    'date': '',
  };

  void DatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectdate = pickedDate;
        print(pickedDate.millisecondsSinceEpoch);
        todo['date'] = pickedDate.millisecondsSinceEpoch.toString();
      });
    });
  }

  void saveForm() {
    final isvalid = _formKey.currentState.validate();
    if (isvalid == false) {
      return;
    }
    _formKey.currentState.save();

    if (_selectdate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Date'),
          content: Text('Please select date to Continue'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('ok'),
            )
          ],
        ),
      );
    }

    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        setState(() {
          isloading = true;
        });
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .addToDo(todo, token)
            .then((value) {
          if (value == 201 || value == 200) {
            setState(() {
              isloading = false;
            });
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Success'),
                content: Text('Successfully added the Data'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      getData();
                    },
                    child: const Text('ok'),
                  )
                ],
              ),
            );
          } else {
            setState(() {
              isloading = false;
            });
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Failed'),
                content: Text('Something went wrong please try again'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      getData();
                    },
                    child: const Text('ok'),
                  )
                ],
              ),
            );
          }
        });
      }
    });
  }

  void getData() {
    setState(() {
      isloading = true;
    });
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .fetchToDo(token)
            .then((value) {
          todoData = value;
          reRun();
        });
      }
    });
  }

  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .fetchToDo(token)
            .then((value) {
          todoData = value;
          reRun();
        });
      }
    });

    super.initState();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  int _count = 0;
  void _update(int count) {
    _count = count;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text('Successfully deleted the Data'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              getData();
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }

  void _edit(int data) {
    // setState(() {
    //   isloading = true;
    // });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO-DO'),
        backgroundColor: Colors.black,
      ),
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          initialValue: title.toString(),
                          decoration: InputDecoration(labelText: 'Title'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a Title';
                            }
                            //this returning null ensures that there is no error
                            return null;
                          },
                          onSaved: (value) {
                            todo['title'] = value;
                          },
                        ),
                        TextFormField(
                          initialValue: description.toString(),
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide description';
                            }
                            //this returning null ensures that there is no error
                            return null;
                          },
                          onSaved: (value) {
                            todo['description'] = value;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _selectdate == null
                                    ? Text('Date Is Not Selected')
                                    : Text(
                                        ' ${DateFormat.yMEd().format(_selectdate)}'),
                                ElevatedButton(
                                    onPressed: DatePicker,
                                    child: Text('Pick Date'))
                              ]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: saveForm,
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: todoData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ToDoData(
                        todoData: todoData,
                        myFormatData: myFormatData,
                        index: index,
                        key: UniqueKey(),
                        tuId: todoData[index]['tuId'],
                        update: _update,
                        edit: _edit,
                      );
                    },
                  ),
                ],
              ),
            ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(
      //     right: 25,
      //     bottom: 25,
      //   ),
      //   child: IconButton(
      //       onPressed: () {
      //         showDialog(
      //           context: context,
      //           builder: (ctx) => AlertDialog(
      //             title: Text('Add Complaint'),
      //             content: Form(
      //               key: _formKey,
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [],
      //               ),
      //             ),
      //             actions: [
      //               FlatButton(
      //                 onPressed: () {
      //                   Navigator.of(ctx).pop();
      //                 },
      //                 child: const Text('ok'),
      //               )
      //             ],
      //           ),
      //         );
      //       },
      //       icon: Icon(
      //         Icons.add_circle,
      //         size: 55,
      //       )),
      // ),
    );
  }
}

class ToDoData extends StatefulWidget {
  const ToDoData({
    Key key,
    @required this.todoData,
    @required this.myFormatData,
    @required this.index,
    @required this.tuId,
    @required this.update,
    @required this.edit,
  }) : super(key: key);

  final List todoData;
  final DateFormat myFormatData;
  final int index;
  final String tuId;
  final ValueChanged<int> update;
  final ValueChanged<int> edit;

  @override
  State<ToDoData> createState() => _ToDoDataState();
}

class _ToDoDataState extends State<ToDoData> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  void delete() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .deleteToDo(widget.tuId, token)
            .then((value) {
          if (value == 201 || value == 200 || value == 204) {
            widget.update(100);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
          onPressed: () {
            // widget.edit({
            //   'title': '${widget.todoData[widget.index]['title']}',
            //   'description': '${widget.todoData[widget.index]['description']}',
            //   'date': '${widget.todoData[widget.index]['date']}',
            //   'tuId': '${widget.tuId}'
            // });
            showDialog(
              context: context,
              builder: (context) {
                var selectdate =
                    DateTime.parse(widget.todoData[widget.index]['date']);
                Map<String, String> todo = {
                  'title': '',
                  'description': '',
                  'date': selectdate.millisecondsSinceEpoch.toString(),
                  'tuId': widget.tuId.toString(),
                };

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text("Edit"),
                      content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              initialValue: widget.todoData[widget.index]
                                  ['title'],
                              decoration: InputDecoration(labelText: 'Title'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide a Title';
                                }
                                //this returning null ensures that there is no error
                                return null;
                              },
                              onSaved: (value) {
                                todo['title'] = value;
                              },
                            ),
                            TextFormField(
                              maxLines: 3,
                              initialValue: widget.todoData[widget.index]
                                  ['description'],
                              decoration:
                                  InputDecoration(labelText: 'description'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide a description';
                                }
                                //this returning null ensures that there is no error
                                return null;
                              },
                              onSaved: (value) {
                                todo['description'] = value;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    selectdate == null
                                        ? Text('Date Is Not Selected')
                                        : Text(
                                            ' ${DateFormat.yMEd().format(selectdate)}'),
                                    ElevatedButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2018),
                                            lastDate: DateTime(2030),
                                          ).then((pickedDate) {
                                            if (pickedDate == null) {
                                              return;
                                            }

                                            setState(() {
                                              selectdate = pickedDate;
                                              print(pickedDate
                                                  .millisecondsSinceEpoch);
                                              todo['date'] = pickedDate
                                                  .millisecondsSinceEpoch
                                                  .toString();
                                            });
                                          });
                                        },
                                        child: Text('Pick Date'))
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            final isvalid = _formKey.currentState.validate();
                            if (isvalid == false) {
                              return;
                            }
                            _formKey.currentState.save();
                            Provider.of<Auth>(context, listen: false)
                                .tryAutoLogin()
                                .then((value) {
                              if (value == true) {
                                var token =
                                    Provider.of<Auth>(context, listen: false)
                                        .token;
                                Provider.of<CustomerList>(context,
                                        listen: false)
                                    .editToDo(todo, token)
                                    .then((value) {
                                  if (value == 201 || value == 200) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Success'),
                                        content: Text(
                                            'Successfully updated the Data'),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              Navigator.pop(context);
                                              widget.edit(100);
                                            },
                                            child: const Text('ok'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                });
                              }
                            });
                          },
                          child: Text("Update"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          icon: Icon(Icons.edit)),
      trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Delete'),
                content: Text('Are you Sure Want to Delete'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('cancel'),
                  ),
                  FlatButton(
                    onPressed: () {
                      delete();
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('ok'),
                  )
                ],
              ),
            );
          },
          icon: Icon(Icons.delete)),
      title: Text('${widget.todoData[widget.index]['title']} '),
      subtitle: Text(
          '${widget.todoData[widget.index]['description']}  ${widget.myFormatData.format(DateTime.parse(widget.todoData[widget.index]['date']))} '),
    );
  }
}
