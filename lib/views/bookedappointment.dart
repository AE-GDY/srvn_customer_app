import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../constants.dart';
import 'package:intl/intl.dart';


class SuccessfulBooking extends StatefulWidget {
  const SuccessfulBooking({Key? key}) : super(key: key);

  @override
  _SuccessfulBookingState createState() => _SuccessfulBookingState();
}

class _SuccessfulBookingState extends State<SuccessfulBooking> {

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

    double newRating = (snapshot.data['$shopIndex']['reviews-rating'] + currentRating) / (snapshot.data['$shopIndex']['reviews-amount']+2);

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
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 200,),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Appointment ", style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
                Text("Confirmed ", style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
          ),
          Expanded(child: Text("${onCalender?globalDay:DateTime.now().day} ${onCalender?DateFormat.LLLL().format(timePicked):DateFormat.LLLL().format(DateTime.now())} ${onCalender?globalYear:DateTime.now().year}, $globalTime",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),),
          Expanded(child: SizedBox(height: 70,),),
          FutureBuilder(
            future: userData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return const Text("There is an error");
                }
                else if(snapshot.hasData){
                  return Container(
                    margin: EdgeInsets.only(bottom: 30,),
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      onPressed: (){

                        Navigator.pushNamed(context, '/');

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

                      },
                      child: Text("Ok, got it!", style: TextStyle(
                        color: Colors.black,
                      ),),
                    ),
                  );
                }
              }
              return const Text("Please wait");
            },

          ),

        ],
      ),
    );

  }
}



