import 'package:booking_app/widgets/bottomnavigator.dart';
import 'package:booking_app/widgets/search.dart';
import 'package:flutter/material.dart';


class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar2(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Points"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed:(){
            showSearch(context: context, delegate: DataSearch(condition: false));
          }),
        ],
      ),
      body: Container(

      ),
    );
  }
}
