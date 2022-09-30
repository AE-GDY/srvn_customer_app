import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';
import 'package:flutter_svg/svg.dart';

import '../services/database.dart';

class NavigationBar2 extends StatefulWidget {
  const NavigationBar2({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar2> {

  DatabaseService databaseService = DatabaseService();

  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }

  double calculateShopRating(AsyncSnapshot<dynamic> snapshot,int shopIndex, int currentRating){

    print('1');

    num totalRatings = 0;
    int reviewIndex = 0;
    while(reviewIndex <= snapshot.data['$currentShopIndex']['reviews-amount']){
      totalRatings += snapshot.data['$currentShopIndex']['reviews']['$reviewIndex']['rating'];
      reviewIndex++;
    }

    double newRating = (totalRatings + currentRating) / (snapshot.data['$shopIndex']['reviews-amount']+2);
    print('2');

    newRating.toStringAsFixed(1);
    print('3');

    return newRating;
  }

  int currentRating = 0;
  TextEditingController reviewController = TextEditingController();

  List<bool> starsSelected = [false,false,false,false,false];

  Future openDialog (int notificationIndex, String notification, String sender, String userName) => showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
        builder: (context, setState){
          return AlertDialog(
            title: Text(notification),
            content: Container(
              width: 200,
              height: 200,
              child: Column(
                children: [
                  Text("Please rate your experience and leave a review!"),
                  SizedBox(height: 10,),
                  Container(
                    width: 300,
                    height: 50,
                    child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          return Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.all(5),
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  int currentIndex = 0;
                                  while(currentIndex <= index){
                                    starsSelected[currentIndex] = true;
                                    currentIndex++;
                                  }


                                  while(currentIndex < 5){
                                    starsSelected[currentIndex] = false;
                                    currentIndex++;
                                  }


                                });
                              },
                              icon: Icon(Icons.star, color: starsSelected[index]?Colors.yellow:Colors.grey,),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                        hintText: "Review"
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            actions: [
              FutureBuilder(
                future: categoryData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("There is an error");
                    }
                    else if(snapshot.hasData){
                      return Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () async {

                            await databaseService.updateNotificationStatus(
                                notificationIndex, userLoggedInIndex
                            );

                            int starIndex = 0;
                            while(starIndex < starsSelected.length){
                              if(starsSelected[starIndex] == true){
                                currentRating++;
                              }
                              starIndex++;
                            }


                            int shopIndex = 0;
                            while(shopIndex <= snapshot.data['total-shop-amount']){

                              if(sender == snapshot.data['$shopIndex']['shop-name']){

                                double newShopRating = calculateShopRating(snapshot,shopIndex, currentRating);

                                await databaseService.addReview(
                                    currentCategory,
                                    shopIndex,
                                    snapshot.data['$shopIndex']['reviews-amount']+1,
                                    reviewController.text,
                                    currentRating,
                                    userName,
                                    newShopRating
                                );

                                break;
                              }

                              shopIndex++;
                            }

                            Navigator.of(context).pop();
                          },
                          child: Text("Submit", style: TextStyle(
                            color: Colors.white,
                          ),),
                        ),
                      );
                    }
                  }
                  return const Text("Please wait");
                },

              ),
            ],
          );
        }
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:50, vertical:10),
      height: 70,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FutureBuilder(
            future: userData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return const Text("There is an error");
                }
                else if(snapshot.hasData){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        activeIndex = 0;
                      });

                      onSettings = false;

                      Navigator.pushNamed(context, '/');

                      if(loggedIn) {

                        if(viewedNotification){
                          viewedNotification = false;
                        }
                        else{
                          int notificationIndex = 0;
                          while(notificationIndex <= snapshot.data['$userLoggedInIndex']['notification-amount']){

                            if(snapshot.data['$userLoggedInIndex']['notifications']['$notificationIndex']['notification-type'] == 'Appointment Complete'){
                              if(snapshot.data['$userLoggedInIndex']['notifications']['$notificationIndex']['viewed'] == false){

                                // Open dialog
                                openDialog(
                                  notificationIndex,
                                  snapshot.data['$userLoggedInIndex']['notifications']['$notificationIndex']['notification'],
                                  snapshot.data['$userLoggedInIndex']['notifications']['$notificationIndex']['sender'],
                                  snapshot.data['$userLoggedInIndex']['full-name'],

                                );

                              }
                            }

                            notificationIndex++;
                          }
                        }
                      }
                    },
                    child: BottomNavItem(currentIndex: 0,title: "Home", icon: Icons.home,),
                  );
                }
              }
              return const Text("Please wait");
            },

          ),
          GestureDetector(
            onTap: (){
              setState(() {
                activeIndex = 1;
              });
              onSettings = false;
              Navigator.pushNamed(context, '/appointments');
            },
            child: BottomNavItem(currentIndex: 1,title: "Appointments", icon: Icons.calendar_today),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                activeIndex = 2;
              });

              onSettings = true;
              Navigator.pushNamed(context, '/profile');
            },
            child: BottomNavItem(currentIndex: 2,title: "Profile", icon: Icons.account_circle),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String title;
  final int currentIndex;
  final IconData icon;
  BottomNavItem({required this.currentIndex, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: (activeIndex == currentIndex)?Colors.black:Colors.grey,),
        SizedBox(height: 5,),
        Text("$title", style: TextStyle(
          color: (activeIndex == currentIndex)?Colors.black:Colors.white,
          fontWeight: (activeIndex == currentIndex)? FontWeight.bold:FontWeight.normal
        ),),
      ],
    );
  }
}