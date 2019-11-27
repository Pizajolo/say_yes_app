import 'package:flutter/material.dart';
import 'package:say_yes_app/services/auth_service.dart';


class SignupPage extends StatefulWidget {
  static final String id = 'signup_page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _username, _email, _password, _street, _houseNumber, _postcode, _city, _country, _surname, _firstName;
  Map _address;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
//      Logging in the user with Firebase
      _address = {
        'street': _street,
        'houseNumber': _houseNumber,
        'postcode': _postcode,
        'city': _city,
        'country': _country,
      };
      AuthService.signUpUser(context, _username, _firstName, _surname, _email, _password, _address);
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0, color: Colors.blueAccent)),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter a valid name'
                              : null,
                          onSaved: (input) => _username = input,
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 150.0,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                ),
                                validator: (input) => input.trim().isEmpty
                                    ? 'Please enter a valid first name'
                                    : null,
                                onSaved: (input) => _firstName = input,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Container(
                              width: 150.0,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Surname',
                                ),
                                validator: (input) => input.trim().isEmpty
                                    ? 'Please enter a valid surname'
                                    : null,
                                onSaved: (input) => _surname = input,
                              ),
                            ),
                          ],
                        ),),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Address:',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 200.0,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Street',
                                  ),
                                  validator: (input) => input.trim().length < 5
                                      ? 'Please enter a valid street name'
                                      : null,
                                  onSaved: (input) => _street = input,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                width: 130.0,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'House Number',
                                  ),
                                  validator: (input) => input.trim().length < 1
                                      ? 'Please enter a valid house number'
                                      : null,
                                  onSaved: (input) => _houseNumber = input,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 200.0,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Post Code',
                                  ),
                                  validator: (input) => input.trim().length < 5
                                      ? 'Please enter a valid post code'
                                      : null,
                                  onSaved: (input) => _postcode = input,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                width: 130.0,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                  ),
                                  validator: (input) => input.trim().length < 3
                                      ? 'Please enter a valid city name'
                                      : null,
                                  onSaved: (input) => _city = input,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Country',
                            ),
                            validator: (input) => input.trim().length < 1
                                ? 'Address is not correct / could not be found /  check all address fields'
                                : null,
                            onSaved: (input) => _country = input,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: _submit,
                          color: Colors.blue,
                          child: Text(
                            'Sign Up',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: () => Navigator.pop(context),
                          color: Colors.blue,
                          child: Text(
                            'Back to Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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
