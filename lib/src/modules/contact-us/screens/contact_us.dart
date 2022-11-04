import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:my_app/src/shared/locale/app_locale.dart';
import 'package:my_app/src/shared/utils/interceptor.dart';
import 'package:provider/provider.dart';


class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  final _formKey = GlobalKey<FormState>();
  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final subject_controller = TextEditingController();
  final message_controller = TextEditingController();

  var _isLoading = false;

  void _onSubmit(){
    setState(() => _isLoading = true);
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}contactus/public';
    endPoint.method = 'post';
    callApi(
        endPoint,
        jsonEncode(<String, dynamic>{
          'name': name_controller.text,
          'email': email_controller.text,
          'subject': subject_controller.text,
          'message': message_controller.text
        }), context
    ).then((result){
      print('result add ${result}');
      setState(() {
        this._isLoading = false;
        _formKey.currentState!.reset();
        name_controller.text = "";
        email_controller.text = "";
        subject_controller.text = "";
        message_controller.text = "";
      });
    }).catchError((error){
      setState(() {
        this._isLoading = false;
      });
    });
  }

  Widget itemContactUs(IconData icon, String title, String subTitle){
    return Padding(
        padding: const EdgeInsets.only(left:15.0,right: 15.0,top:10,bottom: 10),
        // padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(
                icon,
                color: Colors.purple,
              ),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLocale>(builder: (context, provider, snapshot) {
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.contact_us_title_page),
            backgroundColor: Colors.amber[600],
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemContactUs(Icons.email, 'Email', 'srfgroup.contact@gmail.com'),
                  itemContactUs(Icons.phone, 'Téléphoner', '+216 21 636 339 -  +216 73 900 850'),
                  itemContactUs(Icons.share_location, 'Addresse', 'Rue Montreal Skanes ElMechref, 5000, Monastir, Tunisia'),
                  itemContactUs(Icons.map_sharp, 'Google Maps', 'Tunis, Tunisia'),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: name_controller,
                              // keyboardType: TextInputType.emailAddress,
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
                                  labelText: 'Name',
                                  hintText: 'Enter valid name'
                              ),
                              validator: (val) => val!.length < 2
                                  ? 'Please provide a valid email.'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                              validator: (val) => val!.length < 2
                                  ? 'Please provide a valid email.'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: subject_controller,
                              // keyboardType: TextInputType.emailAddress,
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
                                  labelText: 'Subject',
                                  hintText: 'Enter valid subject id as abc@gmail.com'
                              ),
                              validator: (val) => val!.length < 2
                                  ? 'Please provide a valid email.'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: message_controller,
                              // keyboardType: TextInputType.emailAddress,
                              maxLines: 6, //or null
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
                                  labelText: 'Message',
                                  hintText: 'Enter valid message id as abc@gmail.com'
                              ),
                              validator: (val) => val!.length < 2
                                  ? 'Please provide a valid email.'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: (){
                                if( _formKey.currentState!.validate() ){
                                  _isLoading ? null : _onSubmit();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                // padding: const EdgeInsets.all(16.0),
                                  padding: EdgeInsets.only(top: 14.0, bottom: 14.0, right: 30, left: 30),
                                  primary: Colors.purple,
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
                                  : const Icon(Icons.send),
                              label: const Text('Send'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          )
          // body:

      );
    });
  }
}
