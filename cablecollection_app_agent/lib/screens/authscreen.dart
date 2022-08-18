import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/screens/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cablecollection_app/widgets/tabbarcontroller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key key,
  }) : super(key: key);

  static const routeName = '/AuthScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var isloading = false;

  Map<String, String> _authData = {
    'Mobile_Number': '',
    'Password': '',
  };

  void _showErrorDialog(String message) {
    setState(() {
      isloading = false;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occured'),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    // setState(() {
    //   _isLoading = true;
    // });

    try {
      // if (_authMode == AuthMode.Login) {
      // Log user in
      setState(() {
        isloading = true;
      });
      await Provider.of<Auth>(context, listen: false)
          .authenticate(
        _authData['Mobile_Number'],
        _authData['Password'],
      )
          .then((value) {
        setState(() {
          isloading = false;
        });
        if (value == 201 || value == 200) {
          Navigator.of(context).pushNamed(tabBarController.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('LogIn Failed'),
              content: Text('Please check your Mobile Number and Password'),
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
      // } else {
      //   // Sign user up
      //   await Provider.of<Auth>(context, listen: false).signUp(
      //     _authData['email']!,
      //     _authData['password']!,
      //   );
      // }
      //  Navigator.of(context).pushReplacementNamed('/ProductOverviewScreen');
    }
    //  on HttpException
    catch (error) {
      print(error);
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'The password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    }
    //  catch (error) {
    //   var errorMessage = 'Could not authenticate you.Please try again later';
    //   _showErrorDialog(errorMessage);
    // }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final transformConfig = Matrix4.rotationZ(-8 * 3.142 / 180);
    transformConfig.translate(-10.0);
    return Scaffold(
      backgroundColor: Color(0xFFF8EDED),
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: transformConfig,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF3E2C41),
                        boxShadow: [
                          const BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'EazyBill',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Mobile Number'),
                                onSaved: (value) {
                                  _authData['Mobile_Number'] = value;
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                onSaved: (value) {
                                  _authData['Password'] = value;
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              RaisedButton(
                                color: Color(0xFF3E2C41),
                                onPressed: _submit,
                                child: Text(
                                  'LogIn',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              // Text('Or SignUp If you are a new user'),
                              // // FlatButton(
                              //   textColor: Theme.of(context).primaryColor,
                              //   onPressed: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => SignUpScreen(),
                              //       ),
                              //     );
                              //   },
                              //   child: Text(
                              //     'Sign Up',
                              //     style: TextStyle(fontSize: 17),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
