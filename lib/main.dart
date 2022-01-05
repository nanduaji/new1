import 'dart:convert';
// import 'dart:js';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyForm());
}

class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  GlobalKey<FormState> MyFormKey = GlobalKey<FormState>();

  var _name = TextEditingController();

  var _email = TextEditingController();

  var _phone = TextEditingController();

  var _password = TextEditingController();

  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool _obscureTextpwd = true;
  bool _obscureTextcnfpwd = true;
  void _togglepwd() {
    setState(
      () {
        _obscureTextpwd = !_obscureTextpwd;
      },
    );
  }

  void _togglecnfpwd() {
    setState(
      () {
        _obscureTextcnfpwd = !_obscureTextcnfpwd;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registration Form'),
          actions: [],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: MyFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _name,
                      validator: (value) {
                        if (value!.isEmpty) return "Name is required";
                        if (value.length < 3) return "Minimum 3";
                      },
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Please Enter Your Name",
                        icon: Icon(Icons.text_fields),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _email,
                      validator: (value) {
                        if (value!.isEmpty) return "Email is required";
                        final bool isValid = EmailValidator.validate(value);
                        if (isValid == false)
                          return "Please Enter A valid Email";
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Please Enter Your Email",
                        icon: Icon(Icons.email),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _phone,
                      validator: (value) {
                        if (value!.isEmpty) return "Phone Number is required";
                        if (value.length != 10)
                          return "Phone Number Must Be 10 Digits";
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Please Enter Your Phone Number",
                        icon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) {
                        if (value!.isEmpty) return "Password is required";
                        if (value.length < 3)
                          return "Password Should Be Greater Than Or Equal to 3 in Length";
                        if (!regex.hasMatch(value)) {
                          return "password must contain minimum one upper case,minimum one lower case,minimum one numeric number,minimum one special symbol";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Please Enter Your Password",
                        icon: Icon(Icons.password),
                        suffix: InkWell(
                          onTap: _togglepwd,
                          child: _obscureTextpwd == false
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                      ),
                      obscureText: _obscureTextpwd,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: _obscureTextcnfpwd,
                      validator: (value) {
                        if (value != _password.value.text)
                          return 'Please Enter Same Password';
                      },
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Please Confirm Your Password",
                        icon: Icon(Icons.password),
                        suffix: InkWell(
                          onTap: _togglecnfpwd,
                          child: _obscureTextcnfpwd == false
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var name = prefs.getString('name');
                          var email = prefs.getString('email');
                          var phone = prefs.getString('phone');
                          var password = prefs.getString('password');
                          _name = TextEditingController(text: name);
                          _email = TextEditingController(text: email);
                          _phone = TextEditingController(text: phone);
                          _password = TextEditingController(text: password);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (MyFormKey.currentState!.validate())
              print("validated Successfully");

            Register();
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  Future Register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _name.text);
    prefs.setString('email', _email.text);
    prefs.setString('phone', _phone.text);
    prefs.setString('password', _password.text);
  }
}
