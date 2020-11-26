import 'package:flutter/material.dart';
import 'tools/strings.dart';
import 'ui/home.dart';
import 'ui/products_management.dart';
import 'ui/red_cards.dart';

void main() {
  runApp(new MaterialApp(
    title: Strings.app_title,
    home: new Main(),
  ));
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  Widget _body;
  int currentIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _body = Home();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.app_title),
        centerTitle: false,
        actions: [
          IconButton(icon: Icon(Icons.history), onPressed: () => print("clicked !")),
          IconButton(icon: Icon(Icons.show_chart), onPressed: () => print("clicked !"))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: Strings.home),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: Strings.manage_products),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: Strings.red_card),
        ],
        onTap: (value) => _showScreen(value),
        currentIndex: currentIndex,
      ),
      body: _body,
    );
  }

  void _showScreen(value){
    setState(() {
      switch (value) {
        case 0:
          _body = Home();
          break;
        case 1:
          _body = ProductsManagement();
          break;
        case 2:
          _body = RedCard();
          break;
      }
      currentIndex = value;
    });
  }
}


