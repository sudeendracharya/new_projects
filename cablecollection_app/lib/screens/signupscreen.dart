import 'package:cablecollection_app/main.dart';
import 'package:cablecollection_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);
  static const routeName = '/SignUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _authData = {
    'name': '',
    'joinedDate': '2020-11-06',
    'area': '',
    'mobile': null,
    'password': '',
  };

  void submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    await Provider.of<Auth>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<Auth>(context, listen: false)
            .signUp(_authData, token)
            .then((value) {
          if (value == 201 || value == 200) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Success'),
                content: Text('Agent added successfully'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      _formKey.currentState.reset();
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('ok'),
                  )
                ],
              ),
            );

            // setState(() {
            //   _formKey.currentState.reset();
            //   value1 = false;
            //   value2 = false;
            //   value3 = false;
            // });
          } else {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Failed'),
                content: Text('Something went wrong Please try again'),
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
        });
      }
    });
    print(_authData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe8f4f7),
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please Enter the Fallowing Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please provide a Name';
                      }
                      //this returning null ensures that there is no error
                      return null;
                    },
                    onSaved: (value) {
                      _authData['name'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'JoinedDate'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Joinng date cannot be null';
                      }
                      //this returning null ensures that there is no error
                      return null;
                    },
                    onSaved: (value) {
                      _authData['joinedDate'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Area'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Area cannot be null';
                      }
                      //this returning null ensures that there is no error
                      return null;
                    },
                    // validator: (value) {
                    //   if (value.isEmpty || !value.contains('@')) {
                    //     return 'Invalid email!';
                    //   }
                    //   return null;
                    // },
                    onSaved: (value) {
                      _authData['area'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'MobileNumber'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Mobile Number Must not be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['mobile'] = int.tryParse(value.toString());
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm password'),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color(0xFF3E2C41),
                      onPressed: submit,
                      child: Text(
                        'Add Agent',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Text('Or LogIn If You Have a Account'),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: RaisedButton(
                  //     color: Color(0xFF3E2C41),
                  //     onPressed: () {
                  //       Navigator.of(context).pushReplacement(
                  //           MaterialPageRoute(builder: (ctx) => MyApp()));
                  //     },
                  //     child: Text(
                  //       'LogIn',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
