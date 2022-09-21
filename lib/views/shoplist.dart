import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/models/saloonshop.dart';
import 'package:booking_app/models/spashop.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';

class shopList extends StatefulWidget {
  const shopList({Key? key}) : super(key: key);

  @override
  _shopListState createState() => _shopListState();
}

class _shopListState extends State<shopList> {

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
    onShopList = true;
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        leading: FutureBuilder(
          future: userData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return const Text("There is an error");
              }
              else if(snapshot.hasData){
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){

                    Navigator.of(context).pop();

                    if(loggedIn) {

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
                  },
                );
              }
            }
            return const Text("Please wait");
          },

        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Shops", style: TextStyle(
          color: Colors.black,
        ),),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: categoryData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return const Text("There is an error");
            }
            else if(snapshot.hasData){
              return Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: snapshot.data['total-shop-amount'] + 2,
                    itemBuilder: (context, index){
                      if(index == 0){
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                            child: TextField(
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              onTap: (){

                                // SEARCH FUNCTIONALITY NEEDED



                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: onBarberShop?"Search For Barbershop":
                                onSaloonShop?"Search For Hairsalon":
                                "Search For Spa",
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        );
                      }
                      else{
                        return Padding(
                          padding: EdgeInsets.all(0),
                          child: MaterialButton(
                            onPressed: () {


                              onShopList = false;
                              currentShop = snapshot.data['${index-1}']['shop-name'];
                              currentAddress = snapshot.data['${index-1}']['shop-address'];
                              currentShopIndex = index-1;

                              Navigator.pushNamed(context, '/currentshop');

                            },
                            child: Stack(
                              //alignment: Alignment.bottomCenter,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5.0,
                                  child: Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width,
                                   // margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  top: 20,
                                  child: Container(
                                    child: Text(snapshot.data['${index-1}']['shop-name'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  top: 70,
                                  child: Container(
                                    child: Text(snapshot.data['${index-1}']['shop-address'],
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),),
                                  ),
                                ),

                                Positioned(
                                  top: -16,
                                  right: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image.network(
                                      snapshot.data['${index-1}']['images']['${0}'],
                                      alignment: Alignment.center,
                                      fit: BoxFit.fitWidth,
                                      height: 160,
                                      width: 180,
                                    ),
                                  ),
                                ),


                                Positioned(
                                  left: 20,
                                  top: 110,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: createRating(snapshot.data['${index-1}']['reviews-rating']),
                                      ),
                                      SizedBox(height: 0,),
                                      snapshot.data['${index-1}']['reviews-amount'] == 0?
                                      Text('( ${snapshot.data['${index-1}']['reviews-amount']+1} review )'):
                                      Text('( ${snapshot.data['${index-1}']['reviews-amount']+1} reviews )'),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      }
                    }),
              );
            }
          }
          return const Text("Please wait");
        },

      ),
    );
  }


  Widget createRating(double currentRating){

    return  ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      physics: ScrollPhysics(),
      itemBuilder: (context,index){

        return Container(
          child: Icon(Icons.star, color: index < currentRating?Colors.yellow.shade700:Colors.grey),
        );
      },
    );


  }




}
