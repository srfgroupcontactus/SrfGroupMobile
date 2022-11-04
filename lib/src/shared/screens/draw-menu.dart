import 'package:flutter/material.dart';
import '../../modules/contact-us/screens/contact_us.dart';
import 'package:my_app/src/modules/settings/screens/settings.dart';
import '../../modules/user/screens/account/account.dart';
import 'package:my_app/src/modules/user/viewmodel/session.viewmodel.dart';

import '../../modules/user/screens/login/login.dart';
import '../../modules/home/screens/home.screen.dart';
import 'package:provider/provider.dart';

class DrawMenu extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final sessionViewModel = Provider.of<SessionViewModel>(context, listen: true);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black54,
            ),
            child: sessionViewModel.isAuthenticated ? _isAuthDrawerHeader(context, sessionViewModel.currentUser) : _isNotAuthDrawerHeader(context)
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
//              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(title: 'Default')));
            },
          ),
          ExpansionTile(
            title: Text('Support'),
            // subtitle: Text('Trailing expansion arrow icon'),
            children: <Widget>[
              ListTile(
                title: const Text('Contact us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ContactUs()));
                },
              ),
              ListTile(title: Text('About')),
              ListTile(title: Text('Faq')),
            ],
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Settings()));
            },
          ),
        ],
      ),
    );
  }

  _isAuthDrawerHeader(BuildContext context, currentUser){
    print('sessionViewModel.isAuthenticated ${currentUser}');
    return new GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Account()));
      },
      child: ListView(
          children: [
            Container(
              child: CircleAvatar(
                radius: 50, backgroundImage: AssetImage('images/logo.png'),
              ),
            ),
            //These can go here or below the header with the same background color
            Text('${currentUser['firstName']} ${currentUser['lastName']}'),//customize this text
            Text('${currentUser['email']}'),
            //...additional header items here
          ]
      )
    );
  }

  _isNotAuthDrawerHeader(BuildContext context){
    return new GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Login()));
        },
        child: ListView(
            children: [
              Container(
                child: CircleAvatar(
                  // radius: 50, backgroundImage: NetworkImage('https://miro.medium.com/max/554/1*Ld1KM2WSfJ9YQ4oeRf7q4Q.jpeg'),
                  radius: 50, backgroundImage: AssetImage('images/logo.png'),
                ),
              ),
              //These can go here or below the header with the same background color
              Text("SignIn please"),//customize this text
              Text("useremail@example.com"),
              //...additional header items here
            ]
        )
    );
  }
}
