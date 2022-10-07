import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/models/saloonshop.dart';
import 'package:booking_app/models/service_model.dart';
import 'package:booking_app/models/spashop.dart';
import 'package:booking_app/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';


class CurrentShop extends StatefulWidget {

  @override
  _CurrentShopState createState() => _CurrentShopState();
}

String tabSelected = "Services";
class _CurrentShopState extends State<CurrentShop> {


  List<Service> allItems = [];

  List<String> shopServices_name = [];
  String selectedplace='';
  final List<String> suggestedServices =[
    'Devarana Massage',
    'Devarana Spa',
    'Devarana Sauna'
  ];


  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }


  List<String> tabs = ['Services', 'Memberships','Reviews','Portfolio','Details'];


  @override
  Widget build(BuildContext context) {

    dynamic newShop = onBarberShop?bestList[currentShopIndex]:
    onSaloonShop?saloonList[currentShopIndex]: spaList[currentShopIndex];
    globalShop = newShop;
    employeeCount = globalShop.employeeNames.length;

    List<Map<String,String>> serviceList = onBarberShop?barberServiceList:
    onSaloonShop?saloonServiceList:spaServiceList;
    globalServiceList = serviceList;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3 + 20,
              width: MediaQuery.of(context).size.width,
              child:  FutureBuilder(
                future: categoryData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("There is an error");
                    }
                    else if(snapshot.hasData){


                      if(snapshot.data['$currentShopIndex']['total-images'] > 0){
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3 + 20,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data['$currentShopIndex']['total-images'],
                              itemBuilder: (context,index){

                                String url = snapshot.data['$currentShopIndex']['images']['$index'];

                                return Image.network(
                                  url,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  fit: BoxFit.fitWidth,
                                );


                              }),
                        );
                      }
                    }
                  }
                  return (const Center(
                    child: CircularProgressIndicator(),
                  ));
                },

              ),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                SizedBox(width: 20,),
                Expanded(
                  child: Text(
                    currentShop,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 0,),
                FutureBuilder(
                  future: categoryData(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasError){
                        return const Text("There is an error");
                      }
                      else if(snapshot.hasData){

                        dynamic currentShopRating = snapshot.data['$currentShopIndex']['reviews-rating'];

                        dynamic shopRatingRounded = currentShopRating.toStringAsFixed(1);

                        return Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Color(0xffFF8573),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '$shopRatingRounded',
                                style: TextStyle(
                                  color: Color(0xffFF8573),
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),

                            ],
                          ),
                        );
                      }
                    }
                    return const Text("Please wait");
                  },

                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 20,),
                Text(currentAddress,style: TextStyle(
                  fontSize: 16,
                ),),
              ],
            ),
            SizedBox(height: 40,),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemCount: tabs.length,
                  itemBuilder: (context,index){

                    return TextButton(
                      onPressed: (){
                        setState(() {
                          tabSelected = tabs[index];
                          if(tabSelected == 'Packages'){
                            isPackage = true;
                          }
                          else{
                            isPackage = false;
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            width: 80,
                            height: 5,
                            child: Divider(
                              thickness: 3.0,
                              color: tabSelected == tabs[index]?Colors.black:Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );

              }),
            ),

            Divider(
              //height: 5,
              thickness: 1.0,
              color: Colors.grey[400],
            ),
            SizedBox(height: 10,),
            buildBody(),

          ],
        ),
      ),
    );
  }


  Widget buildBody(){
    if(tabSelected == "Services"){
      return Column(
        children: [
          Row(
            children: [
              SizedBox(width:10),

              FutureBuilder(
                future: categoryData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("There is an error");
                    }
                    else if(snapshot.hasData){
                      return Container(
                        width: (MediaQuery.of(context).size.width / 100) * 90,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center,
                          onTap: () async {

                            allItems = [];

                            if(tabSelected == 'Services'){
                              int serviceIndex = 0;
                              while(serviceIndex < snapshot.data['$currentShopIndex']['services-amount']){

                                Service currentService = Service(
                                  serviceIndex: serviceIndex,
                                  name: snapshot.data['$currentShopIndex']['services']['$serviceIndex']['service-name'],
                                  price: snapshot.data['$currentShopIndex']['services']['$serviceIndex']['service-price'],
                                  duration: '${snapshot.data['$currentShopIndex']['services']['$serviceIndex']['service-hours']}${snapshot.data['$currentShopIndex']['services']['$serviceIndex']['service-minutes']}',
                                );

                                allItems.add(currentService);

                                serviceIndex++;
                              }
                            }
                            else{
                              int membershipIndex = 0;
                              while(membershipIndex <= snapshot.data['$currentShopIndex']['memberships-amount']){

                                Service currentService = Service(
                                  serviceIndex: membershipIndex,
                                  name: snapshot.data['$currentShopIndex']['memberships']['$membershipIndex']['name'],
                                  price: snapshot.data['$currentShopIndex']['memberships']['$membershipIndex']['price'],
                                  duration: '${snapshot.data['$currentShopIndex']['memberships']['$membershipIndex']['duration']} month/s',
                                );

                                allItems.add(currentService);

                                membershipIndex++;
                              }
                            }




                            final finalresult = await showSearch(context: context, delegate: DataSearch(type: tabSelected,services: allItems));
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Search For Service",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      );
                    }
                  }
                  return const CircularProgressIndicator();
                },

              ),
            ],
          ),
          SizedBox(height: 10,),


          FutureBuilder(
            future: Future.wait([categoryData(),userData()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return const Text("There is an error");
                }
                else if(snapshot.hasData){


                  String currentMembership = "";
                  List<dynamic> membershipServices = [];
                  List<dynamic> discountedServices = [];
                  List<dynamic> discounts = [];



                  int shopMembersIndex = 0;
                  while(shopMembersIndex <= snapshot.data[0]['$currentShopIndex']['members-amount']){

                    if(snapshot.data[0]['$currentShopIndex']['members']['$shopMembersIndex']['email'] == snapshot.data[1]['$userLoggedInIndex']['email']){
                      currentMembership = snapshot.data[0]['$currentShopIndex']['members']['$shopMembersIndex']['membership-type'];
                      break;
                    }

                    shopMembersIndex++;

                  }

                  int shopMembershipIndex = 0;
                  while(shopMembershipIndex <= snapshot.data[0]['$currentShopIndex']['memberships-amount']){

                    if(currentMembership == snapshot.data[0]['$currentShopIndex']['memberships']['$shopMembershipIndex']['name']){
                      membershipServices = snapshot.data[0]['$currentShopIndex']['memberships']['$shopMembershipIndex']['selected-services'];
                      discountedServices = snapshot.data[0]['$currentShopIndex']['memberships']['$shopMembershipIndex']['selected-discounted-services'];
                      discounts = snapshot.data[0]['$currentShopIndex']['memberships']['$shopMembershipIndex']['selected-discounted-services-percentages'];
                      break;
                    }

                    shopMembershipIndex++;
                  }


                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data![0]['$currentShopIndex']['services-amount'],
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index){

                        String servicePrice = "";
                        String discountedPrice = "";

                        bool promotionFound = false;

                        String promotionDiscount = "";



                        // This while loop will check if there are any flash promotions that are active depending on today's date
                        int promotionIndex = 0;
                        int startMonth = 0;
                        int endMonth = 0;
                        while(promotionIndex < snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions-amount']){

                          int startDay = int.parse(snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-start-day']);
                          int startYear = int.parse(snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-start-year']);

                          int endDay = int.parse(snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-end-day']);
                          int endYear = int.parse(snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-end-year']);

                          // Converting month string to int
                          int monthIndex = 0;
                          while(monthIndex < months.length){

                            print(months[monthIndex]);

                            if(months[monthIndex] == snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-start-month']){

                              print("found start month");
                              startMonth = monthIndex + 1;
                            }
                            if(months[monthIndex] == snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-end-month']){
                              print("found end month");
                              endMonth = monthIndex + 1;
                            }

                            monthIndex++;

                          }

                          print("start date: $startDay/$startMonth/$startYear");
                          print("end date: $endDay/$endMonth/$endYear");

                          if(DateTime.now().year >= startYear && DateTime.now().year <= endYear){
                            if(DateTime.now().month >= startMonth && DateTime.now().month <= endMonth){
                              if(DateTime.now().day >= startDay && DateTime.now().day <= endDay){

                                int percentageDiscount = int.parse(snapshot.data![0]['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-discount']);
                                int serviceOriginalPrice = int.parse(snapshot.data![0]['$currentShopIndex']['services']['$index']['service-price']);

                                double newServicePrice = serviceOriginalPrice - (serviceOriginalPrice * (percentageDiscount / 100));

                                discountedPrice = '${newServicePrice.round()}';

                                promotionDiscount = '$percentageDiscount';

                                promotionFound = true;
                                break;

                              }
                            }
                          }

                          promotionIndex++;
                        }

                        servicePrice = snapshot.data![0]['$currentShopIndex']['services']['$index']['service-price'];


                        // CHECKS IF CURRENT SERVICE IS IN MEMBERSHIP

                        int membershipIdx = 0;

                        bool isInMembership = false;
                        bool isDiscounted = false;


                        while(membershipIdx < membershipServices.length){

                          if(membershipServices[membershipIdx] == snapshot.data![0]['$currentShopIndex']['services']['$index']['service-name']){
                            isInMembership = true;
                            break;
                          }
                          membershipIdx++;
                        }


                        int discountedIndex = 0;
                        while(discountedIndex < discountedServices.length){

                          if(discountedServices[discountedIndex] == snapshot.data![0]['$currentShopIndex']['services']['$index']['service-name']){
                            isDiscounted = true;
                            break;
                          }
                          discountedIndex++;

                        }



                        return ServiceTile(
                            snapshot.data![0]['$currentShopIndex']['services']['$index']['service-name'].toString(),
                            servicePrice,
                            discountedPrice,
                            promotionDiscount,
                            snapshot.data![0]['$currentShopIndex']['services']['$index']['service-hours'].toString(),
                            snapshot.data![0]['$currentShopIndex']['services']['$index']['service-minutes'].toString(),
                            snapshot.data![0]['$currentShopIndex']['services']['$index']['service-linked'],
                            promotionFound,
                            snapshot.data![0]['$currentShopIndex']['services']['$index']['minute-gap'],
                            snapshot.data![0]['$currentShopIndex']['services']['$index']['max-amount-per-timing'].toString(),
                            index,
                            (currentMembership != '' && loggedIn)?isInMembership:false,
                            (currentMembership != '' && loggedIn)?isDiscounted:false,
                            discountedIndex,
                            discounts,
                        );
                      },
                    ),
                  );
                }
              }
              return (const Center(
                child: CircularProgressIndicator(),
              ));            },

          ),
        ],
      );
    }
    else if(tabSelected == 'Packages'){

      return Column(
        children: [
          Row(
            children: [
              SizedBox(width:10),
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 90,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: (){
                    //showSearch(context: context, delegate: DataSearch(condition: true));
                  },
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Search For Package",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),


          FutureBuilder(
            future: categoryData(),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return const Text("There is an error");
                }
                else if(snapshot.hasData){
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!['$currentShopIndex']['packages-amount']+1,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index){
                        //return ServiceTile(serviceList[index], index);
                        return ServiceTile(
                            snapshot.data!['$currentShopIndex']['packages']['$index']['package-name'].toString(),
                            snapshot.data!['$currentShopIndex']['packages']['$index']['package-price'].toString(),
                            'discountedPrice',
                            '0',
                            snapshot.data!['$currentShopIndex']['packages']['$index']['package-hours'].toString(),
                            snapshot.data!['$currentShopIndex']['packages']['$index']['package-minutes'].toString(),
                            snapshot.data!['$currentShopIndex']['packages']['$index']['service-linked'],
                            false,
                            snapshot.data!['$currentShopIndex']['packages']['$index']['minute-gap'],
                            snapshot.data!['$currentShopIndex']['packages']['$index']['max-amount-per-timing'].toString(),
                            index,
                            false,
                            false,
                            0,
                            [],
                        );
                      },
                    ),
                  );
                }
              }
              return (const Center(
                child: CircularProgressIndicator(),
              ));            },

          ),
        ],
      );
    }
    else if(tabSelected == 'Memberships'){
      return Column(
        children: [
          Row(
            children: [
              SizedBox(width:10),
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 90,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: (){
                    showSearch(context: context, delegate: DataSearch(type:'',services: []));
                  },
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Search For Membership",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),


          FutureBuilder(
            future: Future.wait([categoryData(),userData()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return const Text("There is an error");
                }
                else if(snapshot.hasData){

                  bool userIsMember = false;
                  String userMembershipName = "";
                  int membershipIndex = 0;


                  if(loggedIn){
                    while(membershipIndex <= snapshot.data[1]['$userLoggedInIndex']['membership-amount']){

                      if(snapshot.data[1]['$userLoggedInIndex']['memberships']['$membershipIndex']['membership-shop'] == currentShop){
                        userIsMember = true;
                        userMembershipName = snapshot.data[1]['$userLoggedInIndex']['memberships']['$membershipIndex']['membership-name'];
                        break;
                      }

                      membershipIndex++;
                    }
                  }

                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data![0]['$currentShopIndex']['memberships-amount']+1,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index){

                        return MembershipTile(
                            snapshot.data![0]['$currentShopIndex']['memberships']['$index']['name'],
                            snapshot.data![0]['$currentShopIndex']['memberships']['$index']['price'],
                            snapshot.data![0]['$currentShopIndex']['memberships']['$index']['duration'],
                            snapshot.data![0]['$currentShopIndex']['memberships']['$index']['selected-services'],
                            snapshot.data![0]['$currentShopIndex']['services']['$index']['selected-discounted-services'],
                            index,
                            userIsMember,
                            userMembershipName,

                        );
                      },
                    ),
                  );
                }
              }
              return (const Center(
                child: CircularProgressIndicator(),
              ));            },

          ),
        ],
      );
    }
    else if(tabSelected == "Reviews"){


      // REVIEWS NEEDS EDITING

      return FutureBuilder(
        future: categoryData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return const Text("There is an error");
            }
            else if(snapshot.hasData){

              dynamic currentShopRating = snapshot.data['$currentShopIndex']['reviews-rating'];

              dynamic shopRatingRounded = currentShopRating.toStringAsFixed(1);

              return Center(
                child: Column(
                  children: [
                    Container(
                      width: 380,
                      height: 150,
                      child: Card(
                        elevation: 10.0,
                        child: Row(
                          children: [
                            SizedBox(width: 30,),
                            Row(
                              children: [
                                Text("$shopRatingRounded/",style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text("5",style: TextStyle(
                                  fontSize: 20,
                                ),),
                              ],
                            ),
                            SizedBox(width: 40,),
                            VerticalDivider(
                              thickness: 1.0,
                              color: Colors.black,
                            ),
                            SizedBox(width: 20,),
                            Text("Based on ${snapshot.data!['$currentShopIndex']['reviews-amount']+1} reviews",style: TextStyle(
                              fontSize: 16,
                            ),),
                          ],
                        ),
                      ),
                    ),

                    Container(
                        height: 500,
                        child: ListView.builder(
                            itemCount: snapshot.data!['$currentShopIndex']['reviews-amount']+1,
                            itemBuilder: (context,index){
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5.0,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Column(
                                          children: [
                                            Text(snapshot.data['$currentShopIndex']['reviews']['$index']['user'],style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),),

                                            SizedBox(height: 25,),
                                            Text("Review", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                            SizedBox(height: 5,),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              child: Text("${snapshot.data['$currentShopIndex']['reviews']['$index']['comment']}", style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              ),
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                        top: 20,
                                        left: 20,
                                      ),

                                      Positioned(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.star,
                                                size: 22,
                                                color: Color(0xffFF8573),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "${snapshot.data['$currentShopIndex']['reviews']['$index']['rating']}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xffFF8573),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),

                                            ],
                                          ),
                                        top: 20,
                                        right: 20,
                                      ),
                                    ],
                                  ),
                                )
                              );

                        })
                    ),

                  ],
                ),
              );
            }
          }
          return (const Center(
            child: CircularProgressIndicator(),
          ));        },

      );
    }
    else if(tabSelected == "Portfolio"){



      // PORTFOLIO NEEDS EDITING

      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("shops")
            .doc(currentCategory)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['$currentShopIndex']['total-images'] > 0) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                itemCount: snapshot.data['$currentShopIndex']['total-images'],
                itemBuilder: (BuildContext context, int index) {
                  String url = snapshot.data['$currentShopIndex']['images']['$index'];
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.5,
                    margin: EdgeInsets.all(20),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          showImageViewer(context, Image.network(
                            url,fit: BoxFit.fitWidth,).image,
                              swipeDismissible: true,backgroundColor: Colors.blueGrey);
                        },
                        child: Image.network(
                          url,
                          alignment: Alignment.center,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("No images found"),
              );
            }
          } else {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      );
    }
    else{
      return FutureBuilder(
        future: categoryData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Text("There is an error");
            }
            else if(snapshot.hasData){
              return Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address",style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 10,),
                    Text("${snapshot.data['$currentShopIndex']['shop-address']}",style: TextStyle(
                      fontSize: 16,
                    ),),
                    SizedBox(height: 20,),
                    Text("Contact number",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${snapshot.data['$currentShopIndex']['contact-number']}",style: TextStyle(
                          fontSize: 16,
                        ),),
                        Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async {

                              String contactNumber = snapshot.data['$currentShopIndex']['contact-number'];

                              launch('tel://$contactNumber');


                            },
                            child: Text("Call",style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment and Cancellation Policy",style: TextStyle(
                            fontSize: 16,
                          ),),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ) ,
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Report",style: TextStyle(
                            fontSize: 16,
                          ),),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return (const Center(
            child: CircularProgressIndicator(),
          ));        },
      );
    }
  }

}







class ServiceTile extends StatelessWidget {
  final serviceName;
  final servicePrice;
  final serviceDiscountedPrice;
  final serviceDiscount;
  final serviceHours;
  final serviceMinutes;
  //final service;
  final serviceIndex;
  bool serviceLinked;
  bool isPromotion;
  int minuteGap;
  String maxAmountPerTiming;
  bool isInMembership;
  bool isDiscounted;
  int discountedIndex;
  List<dynamic> discounts;
  ServiceTile(
      this.serviceName,
      this.servicePrice,
      this.serviceDiscountedPrice,
      this.serviceDiscount,
      this.serviceHours,
      this.serviceMinutes,
      this.serviceLinked,
      this.isPromotion,
      this.minuteGap,
      this.maxAmountPerTiming,
      this.serviceIndex,
      this.isInMembership,
      this.isDiscounted,
      this.discountedIndex,
      this.discounts,
      );

  @override
  Widget build(BuildContext context) {



    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10,),
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          VerticalDivider(color: Colors.blue,thickness: 2.0,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                child: Text(
                  serviceName,
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
                '${serviceHours} ${serviceMinutes}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              isInMembership?Container():
              isPromotion?Text('${serviceDiscount}% off',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.red,
              ),):isDiscounted?Text('${discounts[discountedIndex]}% off',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.red,
              ),):Container(),

              //

            ],
          ),



          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                '${servicePrice} EGP',
                style: TextStyle(
                  decoration: (isPromotion || isInMembership || isDiscounted)?TextDecoration.lineThrough:TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              isInMembership?Text('FREE!',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.deepOrange,
              ),):
              isPromotion?Text(
                '$serviceDiscountedPrice EGP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.red,
                ),
              ):isDiscounted?Text('${(int.parse(servicePrice) - (int.parse(servicePrice)*(discounts[discountedIndex] / 100))).round()} EGP',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.deepOrange,
              ),):Container(),
              

            ],
          ),
          MaterialButton(
            onPressed: () {

              onCalender = false;
              currentServiceIndex = serviceIndex;
              serviceBooked = serviceName;


              if(isInMembership){
                globalServicePrice = '0';
              }
              else if(isPromotion){
                globalServicePrice = serviceDiscountedPrice;
              }
              else if(isDiscounted){
                globalServicePrice = '${(int.parse(servicePrice) - (int.parse(servicePrice)*(discounts[discountedIndex] / 100))).round()}';
              }
              else{
                globalServicePrice = servicePrice;
              }


              serviceDuration = serviceHours + serviceMinutes;
              globalServiceLinked = serviceLinked;
              globalMinuteGap = minuteGap;
              globalMaxAmount = maxAmountPerTiming;
              typeOfItemSelected = tabSelected;


              if(cashSelected){
                nothingSelected = true;
              }

              cashSelected = false;

              Navigator.pushNamed(context, '/bookingscreen');
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
}

class MembershipTile extends StatelessWidget {
  final name;
  final userIsMember;
  final price;
  final duration;
  final services;
  final discountedServices;
  final membershipIndex;
  final String userMembershipName;

  MembershipTile(
      this.name,
      this.price,
      this.duration,
      this.services,
      this.discountedServices,
      this.membershipIndex,
      this.userIsMember,
      this.userMembershipName,
      );

  @override
  Widget build(BuildContext context) {



    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10,),
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          VerticalDivider(color: Colors.blue,thickness: 2.0,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                child: Text(
                  name,
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
                '$duration month/s',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),



          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$price EGP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),


            ],
          ),
          MaterialButton(
            onPressed: () {


              if(!loggedIn){
                onMembership = true;
                Navigator.pushNamed(context, '/login');
              }
              else if(!userIsMember){
                typeOfItemSelected = tabSelected;
                serviceBooked = name;
                globalServicePrice = price;
                currentMembershipIndex = membershipIndex;

                Navigator.pushNamed(context, '/bookingscreen');
              }


            },
            color: (!userIsMember)?Colors.deepPurple:
            (userIsMember && name == userMembershipName)?Colors.green:
            (userIsMember && name != userMembershipName)?Colors.orange:
            Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              (!userIsMember)?'Purchase':
              (userIsMember && name == userMembershipName)?'Active':
              (userIsMember && name != userMembershipName)?'Unusable':
              '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}