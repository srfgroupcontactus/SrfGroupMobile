import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/src/modules/user/viewmodel/session.viewmodel.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with SingleTickerProviderStateMixin {
  bool _status = true;

  late SharedPreferences accountData;
  var _isLoading = false;

  final firstname_controller = TextEditingController();
  final lastname_controller = TextEditingController();
  final email_controller = TextEditingController();
  final phone_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    this.accountData = await SharedPreferences.getInstance();
    String newCurrentUser = this.accountData.getString(currentUserStorage) ?? '';
    var currentUser = (newCurrentUser!=null) ? json.decode(newCurrentUser) : {};

    firstname_controller.text = currentUser['firstName'];
    lastname_controller.text = currentUser['lastName'];
    email_controller.text = currentUser['email'];
    phone_controller.text = currentUser['phone'];
  }

  void _onLogout(SessionViewModel sessionViewModel) {
    setState(() => _isLoading = true);
    this.accountData.remove(tokenCurrentUserStorage);
    this.accountData.remove(currentUserStorage);
    sessionViewModel.logout();
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(() {
        _isLoading = false;
        Navigator.pop(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionViewModel =
        Provider.of<SessionViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mon compte"),
        backgroundColor: Colors.amber[600],
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 250.0,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: new ExactAssetImage(
                                          'images/defaults/avatar.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Parsonal Information',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: new Text(
                                      'Firstname',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Container(
                                    child: new Text(
                                      'Lastname',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: new TextField(
                                      controller: firstname_controller,
                                      decoration: const InputDecoration(
                                          hintText: "Enter firstname"),
                                      enabled: !_status,
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: new TextField(
                                    controller: lastname_controller,
                                    decoration: const InputDecoration(
                                        hintText: "Enter lastname"),
                                    enabled: !_status,
                                  ),
                                  flex: 2,
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Email ID',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: email_controller,
                                    decoration: const InputDecoration(
                                        hintText: "Enter Email ID"),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Mobile',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: phone_controller,
                                    decoration: const InputDecoration(
                                        hintText: "Enter Mobile Number"),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: new Text(
                                      'Pin Code',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Container(
                                    child: new Text(
                                      'State',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Pin Code"),
                                      enabled: !_status,
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: new TextField(
                                    decoration: const InputDecoration(
                                        hintText: "Enter State"),
                                    enabled: !_status,
                                  ),
                                  flex: 2,
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Column(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: (){

                                    // Init WS
                                    // initWebsocket();

                                    _isLoading ? null : _onLogout(sessionViewModel);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(16.0),
                                      primary: Colors.purple
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
                                      : const Icon(Icons.logout),
                                  label: const Text('Logout'),
                                ),
                              ],
                            )),
                        // !_status ? _getActionButtons() : new Container(),
                        new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*
  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                  child: new Text("Cancel"),
                  textColor: Colors.white,
                  color: Colors.purple,
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
  */

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.purple,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }
}
