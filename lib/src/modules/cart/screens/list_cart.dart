import 'package:flutter/material.dart';
import 'package:my_app/src/modules/cart/screens/infinity_scroll_cart.dart';

class ListCartPage extends StatefulWidget {

  final int selectedIndex;

  const ListCartPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _ListCartPageState createState() => _ListCartPageState();
}

class _ListCartPageState extends State<ListCartPage> {

  StepperType stepperType = StepperType.horizontal;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: Text('Panier'),
                  backgroundColor: Colors.amber[600],
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.purple,
                    tabs: [
                      Tab(child: Text('1 - Valider la commande')),
                      Tab(child: Text('2 - Confirmer la commande')),
                      Tab(child: Text('3 - PAsser la commande'))
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                InfiniteScrollCart(selectedIndex: widget.selectedIndex),
                Icon(Icons.directions_transit, size: 50),
                Icon(Icons.directions_car, size: 50),
              ],
            ),
          )),
    );
  }
}
