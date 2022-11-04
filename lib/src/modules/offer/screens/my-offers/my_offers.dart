import 'package:flutter/material.dart';
import 'package:my_app/src/modules/notification/screens/notification.dart';
import 'package:my_app/src/modules/offer/screens/my-offers/infinite_scroll_my_offer.dart';
import 'package:my_app/src/shared/screens/draw-menu.dart';

class MyOfferPage extends StatefulWidget {

  const MyOfferPage() : super();

  @override
  _MyOfferState createState() => _MyOfferState();
}

class _MyOfferState extends State<MyOfferPage> {

  @override
  Widget build(BuildContext context) {

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
        title: Text('My offers'),
        backgroundColor: Colors.amber[600],
        actions: <Widget>[
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
          ),
        ],
      ),
      body: InfiniteScrollMyOffer(),

      drawer: DrawMenu(),
//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.purple,
//        onPressed:() {
//          Navigator.of(context).push(MaterialPageRoute(
//              builder: (BuildContext context) => AddUpdateOffer()));
//        },
//        tooltip: 'Increment',
//        child: const Icon(Icons.add_circle_rounded),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
