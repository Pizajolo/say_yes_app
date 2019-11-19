import 'package:flutter/material.dart';
import 'package:say_yes_app/pages/signup_page.dart';
import 'package:say_yes_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String  _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Logging in the user with Firebase
      AuthService.login(context, _email, _password);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('SAY YES',
                style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold)),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (input) => input.length < 6
                            ? 'Must be at least 6 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      )),
                  SizedBox(height: 20.0),
                  Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.blue,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, SignupPage.id),
                        color: Colors.blue,
                        child: Text(
                          'Go to Signup',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
