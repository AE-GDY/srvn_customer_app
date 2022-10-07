import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/models/saloonshop.dart';
import 'package:booking_app/models/service_model.dart';
import 'package:booking_app/models/spashop.dart';
import 'package:booking_app/views/currentshopview.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class DataSearch extends SearchDelegate<String>{

  String type;
  List<Service> services;
  DataSearch({
    required this.type,
    required this.services,
  });



  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed:(){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // leading icon on the left of the appbar
    return IconButton(
        icon: AnimatedIcon(
            icon:AnimatedIcons.menu_arrow,
            progress:transitionAnimation
        ),onPressed:(){
      close(context, "null");
    });

  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // show some result based on the selection
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // show when someone searches for something

    final List<Service> suggestionList = services.where((current)=> current.name.toLowerCase().contains(
      query.toLowerCase(),
    ),).toList();

    int currentIdx = 0;
    //final serviceSuggestions = query.isEmpty?
    //recentServices:(services.map((current) => current['title'])).where((element) => element!.startsWith(query)).toList();

    //final currentServices = (services.map((current) =>current)).where((element) => element['title']!.startsWith(query)).toList();

    return Column(
      children: [
        query.isEmpty?
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          child: Text(type == 'Services'?'Recommended Services':'Recommended Memberships',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        ):Container(),

        Expanded(
          child: ListView.builder(
            //condition?serviceSuggestions.length:
              itemCount: suggestionList.length,
              itemBuilder: (context,index) {

                return Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10,),
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            child: Text(
                              suggestionList[index].name, //PROBLEM HERE!!!
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          Text(
                            suggestionList[index].duration,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${suggestionList[index].price} EGP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          /*
                    onCalender = false;
                    int x = 0;
                    while (x < services.length) {
                      if (services[x]['title'] == serviceSuggestions[index]) {
                        currentIdx = x;
                      }
                      x++;
                    }
                    serviceBooked = serviceSuggestions[index];
                    currentServiceIndex = currentIdx;
                    globalServicePrice = currentServices[index]['price'];
                    serviceDuration = currentServices[index]['duration'];
                    print(currentServiceIndex);
                    Navigator.pushNamed(context, '/bookingscreen');
                    */
                        },
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Book',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );


              }
          ),
        ),

      ],
    );



  }
}

