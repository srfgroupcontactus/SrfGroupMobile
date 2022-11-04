import 'package:flutter/material.dart';
import 'package:my_app/src/modules/cart/screens/list_cart.dart';
import 'package:my_app/src/modules/home/screens/home.screen.dart';
import '../../offer/screens/my-offers/my_offers.dart';

int _selectedIndex = 0;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {


  static const TextStyle optionStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    HomePage(title: 'Recherche'),
    ListCartPage(selectedIndex: _selectedIndex),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Search',
      style: optionStyle,
    ),
    MyOfferPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('_selectedIndex ${_selectedIndex}');
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: const Text('BottomNavigationBar Sample'),
//      ),
//      body: Center(
//        child: _widgetOptions.elementAt(_selectedIndex),
//      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        selectedFontSize: 16,
        selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 20),
        selectedItemColor: Colors.amberAccent,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Home',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Business',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
