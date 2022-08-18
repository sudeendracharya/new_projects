import 'package:cablecollection_app/main.dart';
import 'package:cablecollection_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _authData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'mobile': null,
    'password': '',
  };

  void submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    print(_authData);
    Provider.of<Auth>(context, listen: false).signUp(_authData);
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
                    decoration: InputDecoration(labelText: 'FirstName'),
                    onSaved: (value) {
                      _authData['firstName'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'LastName'),
                    onSaved: (value) {
                      _authData['lastName'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email Id'),
                    keyboardType: TextInputType.emailAddress,
                    // validator: (value) {
                    //   if (value.isEmpty || !value.contains('@')) {
                    //     return 'Invalid email!';
                    //   }
                    //   return null;
                    // },
                    onSaved: (value) {
                      _authData['email'] = value;
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
                        'SignUp',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Or LogIn If You Have a Account'),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color(0xFF3E2C41),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => MyApp()));
                      },
                      child: Text(
                        'LogIn',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
