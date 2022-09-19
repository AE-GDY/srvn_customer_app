import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/models/saloonshop.dart';
import 'package:booking_app/models/spashop.dart';
import 'package:booking_app/views/currentshopview.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class DataSearch extends SearchDelegate<String>{

  final bool condition;
  DataSearch({required this.condition});

  List<String> placesNames = [
    bestList[0].name,
    bestList[1].name,
    bestList[2].name,
    bestList[3].name,
    bestList[4].name,
    barbershopList[0].name,
    barbershopList[1].name,
    barbershopList[2].name,
    barbershopList[3].name,
    barbershopList[4].name,
    saloonList[0].name,
    saloonList[1].name,
    saloonList[2].name,
    spaList[0].name,
    spaList[1].name,
    spaList[2].name,
  ];

  dynamic places = [
    bestList[0],
    bestList[1],
    bestList[2],
    bestList[3],
    bestList[4],
    barbershopList[0],
    barbershopList[1],
    barbershopList[2],
    barbershopList[3],
    barbershopList[4],
    saloonList[0],
    saloonList[1],
    saloonList[2],
    spaList[0],
    spaList[1],
    spaList[2],
  ];

  final recentPlaces = [
    barbershopList[3].name,
    barbershopList[4].name,
    saloonList[0].name,
    saloonList[1].name,
  ];

  final recentServices = [
    barberServiceList[0]['title'],
    barberServiceList[1]['title'],
    barberServiceList[2]['title'],
  ];

  final services = onBarberShop?barberServiceList:
  onSaloonShop?saloonServiceList:spaServiceList;


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
    final suggestionList = query.isEmpty
        ?recentPlaces:
    placesNames.where((p)=> p.startsWith(query)).toList();
    int currentIdx = 0;
    final serviceSuggestions = query.isEmpty?
    recentServices:(services.map((current) => current['title'])).where((element) => element!.startsWith(query)).toList();

    final currentServices = (services.map((current) =>current)).where((element) => element['title']!.startsWith(query)).toList();

    return ListView.builder(
        itemCount: condition?serviceSuggestions.length:suggestionList.length,
        itemBuilder: (context,index) {
          if (condition == false) {
            print("FALSE");
            return ListTile(
              onTap: () {
                int x = 0;
                while (x < places.length) {
                  if (places[x].name == suggestionList[index]) {
                    currentIdx = x;
                  }
                  x++;
                }
                print("DONE WITH LOOP");
                if (places[currentIdx].profession == "Barber") {
                  print("BARBERSHOP");
                  onBarberShop = true;
                  onSaloonShop = false;
                  onSpaShop = false;
                }
                else if (places[currentIdx].profession == "Saloon Employee") {
                  print("SALOON");
                  onBarberShop = false;
                  onSaloonShop = true;
                  onSpaShop = false;
                }
                else if (places[currentIdx].profession == "Spa Employee") {
                  print("SPA");
                  onBarberShop = false;
                  onSaloonShop = false;
                  onSpaShop = true;
                }
                close(context, "null");
                currentShopIndex = places[currentIdx].shopIndex;
                Navigator.pushNamed(context, '/currentshop');
              },
              leading: Icon(Icons.location_city),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]
                ),
              ),
            );
          }
          else {
            print("REACHED");
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
                          "${serviceSuggestions[index]}", //PROBLEM HERE!!!
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
                      '${currentServices[index]['duration']} Min',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${currentServices[index]['price']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
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
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
        }
    );
  }
}

