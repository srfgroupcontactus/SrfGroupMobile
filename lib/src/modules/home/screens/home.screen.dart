import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:my_app/src/modules/home/screens/infinite_scroll_paginator.dart';
import 'package:my_app/src/modules/notification/screens/notification.dart';
import 'package:my_app/src/modules/offer/screens/add_update.dart';
import 'package:my_app/src/modules/user/viewmodel/session.viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../shared/screens/draw-menu.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic listOFfers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> sectionsActions(bool isAuthenticated){
    if( isAuthenticated ){
      return [
        IconButton(
            icon: const Icon(Icons.message),
            tooltip: 'Show Snackbar',
            onPressed: () {

            }
        ),
        IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Notifications()));
            }
        )
      ];
    }
    return [];
  }


  @override
  Widget build(BuildContext context) {

    // Remove SplashScreen
    FlutterNativeSplash.remove();

    final sessionViewModel = Provider.of<SessionViewModel>(context, listen: true);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.amber[600],
        actions: sectionsActions(sessionViewModel.isAuthenticated),
      ),
      body: InfiniteScrollPaginator(),

      drawer: DrawMenu(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed:() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddUpdateOffer()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add_circle_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
