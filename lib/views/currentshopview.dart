import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/models/saloonshop.dart';
import 'package:booking_app/models/spashop.dart';
import 'package:booking_app/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CurrentShop extends StatefulWidget {

  @override
  _CurrentShopState createState() => _CurrentShopState();
}

String tabSelected = "Services";
class _CurrentShopState extends State<CurrentShop> {

  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }


  List<String> tabs = ['Services', 'Packages','Reviews','Portfolio','Details'];


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
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    globalShop.image,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.purple.withOpacity(0.1),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
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
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xffFF8573),
                    ),
                    SizedBox(width: 5),
                    Text(
                      newShop.rating,
                      style: TextStyle(
                        color: Color(0xffFF8573),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),

                  ],
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
                    showSearch(context: context, delegate: DataSearch(condition: true));
                  },
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Search For Service",
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
                      itemCount: snapshot.data!['$currentShopIndex']['services-amount'],
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
                        while(promotionIndex < snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions-amount']){

                          int startDay = int.parse(snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-start-day']);
                          int startYear = int.parse(snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-start-year']);

                          int endDay = int.parse(snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-end-day']);
                          int endYear = int.parse(snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-end-year']);

                          // Converting month string to int
                          int monthIndex = 0;
                          while(monthIndex < months.length){

                            print(months[monthIndex]);

                            if(months[monthIndex] == snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-start-month']){

                              print("found start month");
                              startMonth = monthIndex + 1;
                            }
                            if(months[monthIndex] == snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-end-month']){
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

                                int percentageDiscount = int.parse(snapshot.data!['$currentShopIndex']['services']['$index']['flash-promotions']['$promotionIndex']['promotion-discount']);
                                int serviceOriginalPrice = int.parse(snapshot.data!['$currentShopIndex']['services']['$index']['service-price']);

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

                        servicePrice = snapshot.data!['$currentShopIndex']['services']['$index']['service-price'];


                        return ServiceTile(
                            snapshot.data!['$currentShopIndex']['services']['$index']['service-name'].toString(),
                            servicePrice,
                            discountedPrice,
                            promotionDiscount,
                            snapshot.data!['$currentShopIndex']['services']['$index']['service-hours'].toString(),
                            snapshot.data!['$currentShopIndex']['services']['$index']['service-minutes'].toString(),
                            snapshot.data!['$currentShopIndex']['services']['$index']['service-linked'],
                            promotionFound,
                            snapshot.data!['$currentShopIndex']['services']['$index']['minute-gap'],
                            snapshot.data!['$currentShopIndex']['services']['$index']['max-amount-per-timing'].toString(),
                            index
                        );
                      },
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
                    showSearch(context: context, delegate: DataSearch(condition: true));
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
                            index
                        );
                      },
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
                                Text("${snapshot.data!['$currentShopIndex']['reviews-rating']}/",style: TextStyle(
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
                                height: 150,
                                child: Card(
                                  elevation: 5.0,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          child: Text(snapshot.data['$currentShopIndex']['reviews']['$index']['user'],style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        top: 20,
                                        left: 20,
                                      ),
                                      Positioned(
                                          child: Text("Review: ${snapshot.data['$currentShopIndex']['reviews']['$index']['comment']}", style: TextStyle(
                                            fontSize: 16,
                                          ),),
                                        top: 70,
                                        left: 20,
                                      ),

                                      Positioned(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Color(0xffFF8573),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "${snapshot.data['$currentShopIndex']['reviews']['$index']['rating']}",
                                                style: TextStyle(
                                                  color: Color(0xffFF8573),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),

                                            ],
                                          ),
                                        top: 100,
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
          return const Text("Please wait");
        },

      );
    }
    else if(tabSelected == "Portfolio"){



      // PORTFOLIO NEEDS EDITING

      return Center(
        child: Column(
          children: [
            SizedBox(height: 90,),
            Text("Portfolio is empty",style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
          ],
        ),
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
                      children: [
                        Text("${snapshot.data['$currentShopIndex']['contact-number']}",style: TextStyle(
                          fontSize: 16,
                        ),),
                        SizedBox(width: 180,),
                        Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: (){},
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
                        children: [
                          Text("Payment and Cancellation Policy",style: TextStyle(
                            fontSize: 16,
                          ),),
                          SizedBox(width: 60,),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ) ,
                    SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text("Report",style: TextStyle(
                            fontSize: 16,
                          ),),
                          SizedBox(width: 270,),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Text("Please wait");
        },
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

              isPromotion?Text('${serviceDiscount}% off',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.red,
              ),):Container(),
            ],
          ),



          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${servicePrice} EGP',
                style: TextStyle(
                  decoration: isPromotion?TextDecoration.lineThrough:TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              isPromotion?Text(
                '$serviceDiscountedPrice EGP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.red,
                ),
              ):Container(),

            ],
          ),
          MaterialButton(
            onPressed: () {

              onCalender = false;
              currentServiceIndex = serviceIndex;
              serviceBooked = serviceName;
              globalServicePrice = servicePrice;
              serviceDuration = serviceHours + serviceMinutes;
              globalServiceLinked = serviceLinked;
              globalMinuteGap = minuteGap;
              globalMaxAmount = maxAmountPerTiming;
              typeOfItemSelected = tabSelected;

              Navigator.pushNamed(context, '/bookingscreen');
            },
            color: Colors.blue,
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