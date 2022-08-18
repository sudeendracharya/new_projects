import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IndividualCustomerComplaint extends StatefulWidget {
  IndividualCustomerComplaint({Key key}) : super(key: key);

  static const routeName = '/IndividualCustomerComplaint';

  @override
  _IndividualCustomerComplaintState createState() =>
      _IndividualCustomerComplaintState();
}

class _IndividualCustomerComplaintState
    extends State<IndividualCustomerComplaint> {
  var cusId;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var myFormatData = DateFormat('dd-MM-yyyy');
  var _selectdate;
  var title;
  var description;
  List complaints = [];
  var isloading = true;

  Map<String, String> todo = {
    'title': '',
    'description': '',
    'date': '',
    'cuId': '',
  };

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    cusId = ModalRoute.of(
      context,
    ).settings.arguments;
    if (cusId != null) {
      todo['cuId'] = cusId;
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<CustomerList>(context, listen: false)
              .fetchSingleCustomerComplaint(cusId, token)
              .then((value) {
            complaints = value;
            reRun();
          });
        }
      });
    }
    super.didChangeDependencies();
  }

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
            .addComplaints(todo, token)
            .then((value) {
          setState(() {
            isloading = false;
          });
          if (value == 201 || value == 200) {
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
          }
        });
      }
    });
  }

  void getData() {
    setState(() {
      isloading = true;
    });
    cusId = ModalRoute.of(
      context,
    ).settings.arguments;
    if (cusId != null) {
      todo['cuId'] = cusId;
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<CustomerList>(context, listen: false)
              .fetchSingleCustomerComplaint(cusId, token)
              .then((value) {
            complaints = value;
            reRun();
          });
        }
      });
    }
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

  void get(int count) {
    _count = count;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints'),
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
                          //initialValue: title.toString(),
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
                          // initialValue: description.toString(),
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
                    itemCount: complaints.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ComplaintListData(
                        complaints: complaints,
                        myFormatData: myFormatData,
                        index: index,
                        key: UniqueKey(),
                        compId: complaints[index]['compId'],
                        update: _update,
                        get: get,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class ComplaintListData extends StatefulWidget {
  ComplaintListData({
    Key key,
    @required this.complaints,
    @required this.myFormatData,
    @required this.index,
    @required this.compId,
    @required this.update,
    @required this.get,
  }) : super(key: key);

  final List complaints;
  final DateFormat myFormatData;
  final int index;
  var compId;
  final ValueChanged<int> update;
  final ValueChanged<int> get;

  @override
  State<ComplaintListData> createState() => _ComplaintListDataState();
}

class _ComplaintListDataState extends State<ComplaintListData> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  void delete() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .deleteComplaint(widget.compId, token)
            .then((value) {
          if (value == 201 || value == 200) {
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
            showDialog(
              context: context,
              builder: (context) {
                var selectdate =
                    DateTime.parse(widget.complaints[widget.index]['date']);
                Map<String, String> todo = {
                  'title': '',
                  'description': '',
                  'date': selectdate.millisecondsSinceEpoch.toString(),
                  'compId': widget.compId.toString(),
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
                              initialValue: widget.complaints[widget.index]
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
                              initialValue: widget.complaints[widget.index]
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
                                    .editComplaint(todo, token)
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
                                              widget.get(100);
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
      title: Text(widget.complaints[widget.index]['title']),
      subtitle: Text(
          '${widget.complaints[widget.index]['description']} ${widget.myFormatData.format(DateTime.parse(widget.complaints[widget.index]['date']))}'),
    );
  }
}
