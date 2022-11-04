import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:my_app/src/modules/user/screens/activate-account/activate-account.dart';
import 'package:my_app/src/shared/locale/app_locale.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../shared/utils/interceptor.dart';
import 'dart:convert';

import 'package:my_app/src/shared/constants/constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  var _isLoading = false;

  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final conf_password_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register(String email, String password){

    setState(() => _isLoading = true);
    OneSignal.shared.getDeviceState().then((deviceState) {

      EndPoint endPoint = EndPoint();
      endPoint.url = '${baseUrl}user/public/signup';
      endPoint.method = 'post';
      callApi(
          endPoint,
          jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'idOneSignal': (deviceState != '') ? deviceState!.userId! : '',
          }), context
      ).then((result){
        print('Success response: ${result}');
        setState(() {
          if(result){
            _isLoading = false;
            Navigator.push(context, MaterialPageRoute(builder: (context) => ActivateAccount()));
          }
        });
      }).catchError((error){
        setState(() => _isLoading = false);
        print('Error response: ${error}');
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLocale>(builder: (context, provider, snapshot) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Register Page"),
            backgroundColor: Colors.amber[600],
          ),
          body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0, bottom: 30),
                      child: Center(
                        child: Container(
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50.0)),
                            child: Image.asset('images/logo.png')),
                      ),
                    ),
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: email_controller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.purple
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.purple),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter valid email id as abc@gmail.com'
                        ),
                        validator: (val) =>
                        !EmailValidator.validate(val!, true)
                            ? 'Please provide a valid email.'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: password_controller,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.purple
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.purple),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter secure password'
                        ),
                        validator: (val) =>
                        val!.length < 4
                            ? 'Your password is too Password too short..'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: conf_password_controller,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.purple
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.purple),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Conf Password',
                            hintText: 'Enter secure password'
                        ),
                        validator: (val) =>
                        val!.length < 4
                            ? 'Your password is too Password too short..'
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          String email = email_controller.text;
                          String password = password_controller.text;
                          String confPassword = conf_password_controller.text;
                          print('username: ${email}');
                          print('password: ${password}');
                          print('confPassword: ${confPassword}');

                          print('form?.validate() ${_formKey.currentState!
                              .validate()}');
                          if (_formKey.currentState!.validate()) {
                            _register(email, password);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          // padding: const EdgeInsets.all(16.0),
                            padding: EdgeInsets.only(
                                top: 14.0, bottom: 14.0, right: 30, left: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  35), // <-- Radius
                            )
                        ),
                        icon: _isLoading
                            ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                            : const Icon(Icons.login),
                        label: const Text('Register'),
                      ),
                    ),
                    //              SizedBox(
                    //                height: 30,
                    //              ),
                    //              Container(
                    //                height: 40,
                    //                width: 250,
                    //                decoration: BoxDecoration(
                    //                    color: Colors.purple,
                    //                    borderRadius: BorderRadius.circular(20)
                    //                ),
                    //                child: TextButton(
                    //                  onPressed: () {
                    //                    String email = email_controller.text;
                    //                    String password = password_controller.text;
                    //                    String confPassword = conf_password_controller.text;
                    //                    print('username: ${email}');
                    //                    print('password: ${password}');
                    //                    print('confPassword: ${confPassword}');
                    //
                    //                    print('form?.validate() ${_formKey.currentState!.validate()}');
                    //                    if( _formKey.currentState!.validate() ){
                    //                      _register(email, password);
                    //                    }
                    //                  },
                    //                  child: Text(
                    //                    'Register',
                    //                    style: TextStyle(color: Colors.white, fontSize: 15),
                    //                  ),
                    //                ),
                    //              ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: TextButton(
                          onPressed: () {
                            //TODO FORGOT PASSWORD SCREEN GOES HERE
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        )),
                  ],
                ),
              )
          )
      );
    });
  }
}
