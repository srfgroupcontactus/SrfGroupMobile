import 'package:flutter/material.dart';
import '../../../../shared/utils/interceptor.dart';
import '../login/login.dart';

import 'package:my_app/src/shared/constants/constants.dart';

class ActivateAccount extends StatefulWidget {
  @override
  _ActivateAccountState createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {

  var _isLoading = false;
  final code_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _activate(String key){

    setState(() => _isLoading = true);
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}user/public/activate-account?key=${key}';
    endPoint.method = 'get';
    callApi( endPoint,{}, context ).then((result){
      print('Success response: ${result}');
      setState(() {
        if(result){
          _isLoading = false;
          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
        }
      });
    }).catchError((error){
      setState(() => _isLoading = false);
      print('Error response =: ${error}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Activation Account"),
          backgroundColor: Colors.amber[600],
        ),
        body: Form(
          key: _formKey,
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
                  controller: code_controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Code',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                  validator: (val) => val!.length < 1 ? 'Your code is too Password too short..' : null,
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
                    String code = code_controller.text;
                    print('code: ${code}');

                    print('form?.validate() ${_formKey.currentState!.validate()}');
                    if( _formKey.currentState!.validate() ){
                      _activate(code);
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
                  label: const Text('Activate'),
                ),
              ),

//              Container(
//                height: 50,
//                width: 250,
//                decoration: BoxDecoration(
//                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
//                child: TextButton(
//                  onPressed: () {
//                    String code = code_controller.text;
//                    print('code: ${code}');
//
//                    print('form?.validate() ${_formKey.currentState!.validate()}');
//                    if( _formKey.currentState!.validate() ){
//                      _activate(code);
//                    }
//                  },
//                  child: Text(
//                    'Activate',
//                    style: TextStyle(color: Colors.white, fontSize: 25),
//                  ),
//                ),
//              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  )),
            ],
          ),
        )
    );

  }
}
