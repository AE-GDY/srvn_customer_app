import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/models/category.dart';
import 'package:booking_app/models/saloonshop.dart';
import 'package:booking_app/models/shop_model.dart';
import 'package:booking_app/models/spashop.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';

import '../widgets/searchh.dart';

class shopList extends StatefulWidget {
  const shopList({Key? key}) : super(key: key);

  @override
  _shopListState createState() => _shopListState();
}

class _shopListState extends State<shopList> {

  DatabaseService databaseService = DatabaseService();

  List<Shop> allShops = [];

  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }


  Future<Map<String, dynamic>?> barbershopData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc('Barbershop').get()).data();
  }

  Future<Map<String, dynamic>?> hairsalonData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc('Hair Salon').get()).data();
  }

  Future<Map<String, dynamic>?> spaData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc('Spa').get()).data();
  }

  Future<Map<String, dynamic>?> gymData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc('Gym').get()).data();
  }

  Future<Map<String, dynamic>?> carData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc('Car Wash').get()).data();
  }


  double calculateShopRating(AsyncSnapshot<dynamic> snapshot,int categoryIndex,int shopIndex, int currentRating){

    print('1');

    num totalRatings = 0;
    int reviewIndex = 0;
    while(reviewIndex <= snapshot.data[categoryIndex]['$shopIndex']['reviews-amount']){
      totalRatings += snapshot.data[categoryIndex]['$shopIndex']['reviews']['$reviewIndex']['rating'];
      reviewIndex++;
    }

    double newRating = (totalRatings + currentRating) / (snapshot.data[categoryIndex]['$shopIndex']['reviews-amount']+2);
    print('2');

    newRating.toStringAsFixed(1);
    print('3');

    return newRating;
  }


  int currentRating = 0;
  TextEditingController reviewController = TextEditingController();

  List<bool> starsSelected = [true,true,true,true,true];

  Future openDialog (int notificationIndex, String notification, String sender, String userName) => showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
        builder: (context, setState){
          return AlertDialog(
            title: Text(sender, style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,),
            content: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text("Appointment Complete", textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),

                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text("Please rate your experience and leave a review!", textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,

                      ),),
                  ),
                 // SizedBox(height: 10,),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width:MediaQuery.of(context).size.width / 1.6,
                      height: 50,
                      child: Center(
                        child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                              //  margin: EdgeInsets.all(5),
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
                                  icon: Icon(Icons.star, color: starsSelected[index]?Colors.yellow.shade700:Colors.grey,),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                //  SizedBox(height: 10,),
                  Expanded(
                    child: TextField(
                      controller: reviewController,
                      decoration: InputDecoration(
                          hintText: "Review"
                      ),
                    ),
                  ),
                 // SizedBox(height: 10,),
                ],
              ),
            ),
            actions: [
              FutureBuilder(
                future: Future.wait([hairsalonData(),barbershopData(),spaData(),gymData(), carData()]),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("There is an error");
                    }
                    else if(snapshot.hasData){
                      return Center(
                        child: Container(
                          width: 250,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
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

                              bool foundCategory = false;
                              int categoryIndex = 0;
                              while(categoryIndex < categoryList.length){
                                int shopIndex = 0;
                                while(shopIndex <= snapshot.data[categoryIndex]['total-shop-amount']){
                                  if(sender == snapshot.data[categoryIndex]['$shopIndex']['shop-name']){
                                    print('4');
                                    double newShopRating = calculateShopRating(snapshot,categoryIndex,shopIndex, currentRating);
                                    print('5');
                                    foundCategory = true;

                                    await databaseService.addReview(
                                        currentCategory,
                                        shopIndex,
                                        snapshot.data[categoryIndex]['$shopIndex']['reviews-amount']+1,
                                        reviewController.text,
                                        currentRating,
                                        userName,
                                        newShopRating
                                    );

                                    break;
                                  }
                                  shopIndex++;
                                }

                                if(foundCategory){
                                  break;
                                }

                                categoryIndex++;
                              }

                              viewedNotification = true;

                              Navigator.of(context).pop();

                            },
                            child: Text("Submit", style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[50],
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

                    Navigator.popAndPushNamed(context, '/');

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
                              onTap: () async {

                                // SEARCH FUNCTIONALITY NEEDED

                                allShops = [];

                                int shopIndex = 0;
                                while(shopIndex <= snapshot.data['total-shop-amount']){

                                  dynamic currentRating = snapshot.data['$shopIndex']['reviews-rating'];

                                  dynamic ratingRounded = currentRating.toStringAsFixed(1);

                                  Shop currentShop = Shop(
                                      shopName: snapshot.data['$shopIndex']['shop-name'],
                                      shopCategory: currentCategory,
                                      shopAddress: snapshot.data['$shopIndex']['shop-address'],
                                      shopReviewAmount: snapshot.data['$shopIndex']['reviews-amount']+1,
                                      shopRating: ratingRounded,
                                      imageUrl: snapshot.data['$shopIndex']['images']['${-1}'],
                                      shopIndex: shopIndex
                                  );

                                  allShops.add(currentShop);

                                  shopIndex++;
                                }

                                final finalresult = await showSearch(context: context, delegate: search_service(allServices: [], shops: allShops));

                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: currentCategory == 'Barbershop'?"Search For Barbershops":
                                currentCategory == 'Hair Salon'?"Search For Hair salons":
                                currentCategory == 'Gym'?"Search For Gyms":
                                currentCategory == 'Spa'?"Search For Spas":
                                currentCategory == 'Pet Services'?'Search for Pet Services':
                                currentCategory == 'Restaurants'?'Search for Restaurants':
                                'Search for Local Brands',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        );
                      }
                      else{
                        return Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            children: [
                              MaterialButton(
                                onPressed: () {


                                  onShopList = false;
                                  currentShop = snapshot.data['${index-1}']['shop-name'];
                                  currentAddress = snapshot.data['${index-1}']['shop-address'];
                                  currentShopIndex = index-1;

                                  Navigator.pushNamed(context, '/currentshop');

                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height / 4,
                                  padding: EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      snapshot.data['${index-1}']['images']['${0}'],
                                      alignment: Alignment.center,
                                      fit: BoxFit.fitWidth,

                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 5,),

                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(snapshot.data['${index-1}']['shop-name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                        ),

                                        Container(
                                          child: Text(snapshot.data['${index-1}']['shop-address'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600],
                                            ),),
                                        ),
                                      ],
                                    ),

                                    Column(
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

                                  ],
                                ),
                              ),


                              SizedBox(height: 20,),




                            ],
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


  Widget createRating(dynamic currentRating){

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
