import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_app/src/modules/user/viewmodel/session.viewmodel.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';

import '../../../../shared/utils/interceptor.dart';
import '../../../home/screens/home.screen.dart';

//import OneSignal
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  late SharedPreferences loginData;
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  var _isLoading = false;
  bool rememberMe = true;


  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Exception = ${error}');
    }
  }

  void _getSession(SessionViewModel sessionViewModel){

    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}user/current-user';
    endPoint.method = 'get';
    callApi( endPoint, {}, context ).then((result){
      print('Success response: ${result}');
      setState(() {
        this.loginData.setString(currentUserStorage, json.encode(result) );

        sessionViewModel.sessionUser().then((value) => {
          Navigator.pop(context)
        });
      });
    }).catchError((error){
      print('Error response: ${error}');
    });
  }

  void _login(String email,
      String password,
      SessionViewModel sessionViewModel){

    setState(() => _isLoading = true);
    OneSignal.shared.getDeviceState().then((deviceState) {
      print("DeviceState: ${deviceState?.userId}");

      EndPoint endPoint = EndPoint();
      endPoint.url = '${baseUrl}user/public/signin';
      endPoint.method = 'post';
      callApi(
          endPoint,
          jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'rememberMe': 'false',
            'idOneSignal': (deviceState != '') ? deviceState!.userId! : ''
          }), context
      ).then((result){
        print('Success response: ${result['id_token']}');
        setState(() {
          this.loginData.setString('tokenCurrentUser', result['id_token']);
          _getSession(sessionViewModel);
          this._isLoading = false;
        });
      }).catchError((error){
        setState(() => _isLoading = false);
        print('Error response: ${error}');
      });

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    this.loginData = await SharedPreferences.getInstance();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      print('GoogleSignInAccount : ${account}');
    });
    _googleSignIn.signInSilently();
  }

  void _onLoggedIn(SessionViewModel sessionViewModel) {
    String email = email_controller.text;
    String password = password_controller.text;
    print('username: ${email}');
    print('password: ${password}');

    print('form?.validate() ${_formKey.currentState!.validate()}');

    if( _formKey.currentState!.validate() ){
      _login(email, password, sessionViewModel);
    }
  }

  @override
  Widget build(BuildContext context) {

    final sessionViewModel = Provider.of<SessionViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                          borderSide: BorderSide(width: 1, color: Colors.purple),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 5,
                                color: Colors.purple
                            )
                        ),
                        labelText: 'Email',
                        hintText: 'Enter valid email id as abc@gmail.com'
                    ),
                    validator: (val) => !EmailValidator.validate(val!, true)
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
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.purple
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.purple),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password',
                      suffixIcon: new GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child:
                        new Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.purple,),
                      ),
                    ),
                    validator: (val) => val!.length < 4 ? 'Your password is too Password too short..' : null,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          checkColor: Colors.amber,
                          activeColor: Colors.purple,
                          value: rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                               this.rememberMe = value!=null && value==true ? true : false;
                            });
                          },
                        ),
                        Text('Remember me',style: TextStyle(fontSize: 17.0), ),
                        Expanded(                           //added expanded over here
                          child: TextButton(
                            onPressed: () {
                              //TODO FORGOT PASSWORD SCREEN GOES HERE
                            },
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(color: Colors.purple, fontSize: 15),
                            ),
                          )
                        ),
                      ],
                    ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(35),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      _isLoading ? null : _onLoggedIn(sessionViewModel);
                    },
                    style: ElevatedButton.styleFrom(
                        // padding: const EdgeInsets.all(16.0),
                        padding: EdgeInsets.only(top: 14.0, bottom: 14.0, right: 30, left: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35), // <-- Radius
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
                    label: const Text('Login'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      // child: const Icon(Icons.add),
                      child: const Text("F"),
                      style: OutlinedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(24),
                          backgroundColor: Colors.blue
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _handleSignIn();
                      },
                      // child: const Icon(Icons.add),
                      child: const Text("G"),
                      style: OutlinedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(24),
                          backgroundColor: Colors.red
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: (){
          Navigator.pushNamed(context, "register");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.person_add),
      )
    );
  }
}
