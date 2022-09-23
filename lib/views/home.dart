import 'package:booking_app/constants.dart';
import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/models/category.dart';
import 'package:booking_app/models/spashop.dart';
import 'package:booking_app/services/database.dart';
import 'package:booking_app/widgets/barbershop.dart';
import 'package:booking_app/widgets/bottomnavigator.dart';
import 'package:booking_app/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import '../models/saloonshop.dart';
import '../widgets/searchh.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late  List<String> shopServices_name = [];
  String selectedplace='';
  final List<String> suggestedServices =[
    'massage',
    'spa',
    'jacosey'
  ];

  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }

  DatabaseService databaseService = DatabaseService();

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }

  Future openDialog (int notificationIndex, String notification) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(notification),
      content: Container(
        width: 200,
        height: 400,
        child: Column(
          children: [
            Text("Please rate your experience and leave a review!"),
            SizedBox(height: 10,),
            TextField(
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
          future: userData(),
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
    ),
  );



  @override
  Widget build(BuildContext context) {

    activeIndex = 0;
    return Scaffold(
      bottomNavigationBar: NavigationBar2(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width / 100) * 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          //color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center,
                          onTap: () async {
                            final finalresult = await showSearch(context: context, delegate: search_service(allServices: shopServices_name, servicesSuggestion: suggestedServices));
                            setState(() {
                              selectedplace=finalresult!;
                              print(selectedplace);
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: onBarberShop
                                ? "Search For Barbershop"
                                : onSaloonShop
                                ? "Search For Hairsalon"
                                : "Search For Spa",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),

                      FutureBuilder(
                        future: userData(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasError){
                              return const Text("There is an error");
                            }
                            else if(snapshot.hasData){

                              int notificationIndex = 0;
                              int activeNotifications = 0;

                              while(notificationIndex <= snapshot.data['$userLoggedInIndex']['notification-amount']){

                                if(snapshot.data['$userLoggedInIndex']['notifications']['$notificationIndex']['viewed'] == false){
                                  activeNotifications++;
                                }

                                notificationIndex++;
                              }


                              return buttonWithIcon(
                                svgSrc: "assets/all_images/Bell.svg",
                                press: (){

                                },
                                numOfItems: (loggedIn == false)?0:activeNotifications,
                              );
                            }
                          }
                          return const Text("Please wait");
                        },

                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              /*
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width / 100) * 7,
                  vertical: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text.rich(
                  TextSpan(
                      text: "A Summer Surprise\n",
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "Cashback 20%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              */
              FutureBuilder(
                future: userData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("There is an error");
                    }
                    else if(snapshot.hasData){

                      String currentName = "";

                      if(loggedIn){

                        int userNameIndex = 0;

                        String userFullName = snapshot.data['$userLoggedInIndex']['full-name'];

                        while(userNameIndex < userFullName.length){

                          if(userFullName[userNameIndex] == " "){
                            break;
                          }
                          currentName += userFullName[userNameIndex];
                          userNameIndex++;
                        }
                      }
                      else{
                        currentName = "Guest";
                      }

                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hey, $currentName", style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),),
                          ],
                        ),
                      );

                    }
                  }
                  return const Text("Please wait");
                },

              ),
              SizedBox(height: 5,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Categories", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),),
                    Text("See More"),
                  ],
                ),
              ),
              SizedBox(height: 0,),
              Container(
                height: 140,
                child:ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index){
                    var category = categoryList[index];
                    return Container(
                      //margin: EdgeInsets.all(5),
                      width: 110,
                      height: 200,
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Container(
                              height: 70,
                              width: 70,
                              padding: EdgeInsets.all((MediaQuery.of(context).size.width / 100) * 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if(category.title == "Hair Salon"){
                                    setState(() {
                                      currentCategory = "Hair Salon";
                                      onBarberShop = false;
                                      onSpaShop = false;
                                      onSaloonShop = true;
                                    });
                                  }
                                  else if(category.title == "Barbershop"){
                                    setState(() {
                                      currentCategory = "Barbershop";
                                      onBarberShop = true;
                                      onSpaShop = false;
                                      onSaloonShop = false;
                                    });

                                  }
                                  else if(category.title == "Spa"){
                                    setState(() {
                                      currentCategory = "Spa";
                                      onBarberShop = false;
                                      onSpaShop = true;
                                      onSaloonShop = false;
                                    });

                                  }
                                  Navigator.pushNamed(context, '/shoplist');
                                },
                                child: SvgPicture.asset(category.icon),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(category.title, textAlign: TextAlign.center, style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Top Barbershops", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),),
                    Text("See More"),
                  ],
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: bestList.length,
                  //return BarbershopCard(barbershop: barbershop, barberIndex: index,);
                  itemBuilder: (context, index){
                    var currentShop = bestList[index];
                    return shopCard(barbershop: currentShop, barberIndex: index,);
                  },
                ),
              ),

              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Top Hair Salons", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),),
                    Text("See More"),
                  ],
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: saloonBestList.length,
                  //return BarbershopCard(barbershop: barbershop, barberIndex: index,);
                  itemBuilder: (context, index){
                    var currentShop = saloonBestList[index];
                    return shopCard(barbershop: currentShop, barberIndex: index,);
                  },
                ),
              ),


              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Top Spas", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),),
                    Text("See More"),
                  ],
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: spaBestList.length,
                  //return BarbershopCard(barbershop: barbershop, barberIndex: index,);
                  itemBuilder: (context, index){
                    var currentShop = spaBestList[index];
                    return shopCard(barbershop: currentShop, barberIndex: index,);
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class buttonWithIcon extends StatefulWidget {
  const buttonWithIcon({Key? key, required this.svgSrc, this.numOfItems = 0, required this.press}) : super(key: key);

  final String svgSrc;
  final int numOfItems;
  final GestureTapCallback press;

  @override
  _buttonWithIconState createState() => _buttonWithIconState();
}

class _buttonWithIconState extends State<buttonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        clipBehavior: Clip.none, children: [
        Container(
          padding: EdgeInsets.all((MediaQuery
              .of(context)
              .size
              .width / 100) * 2),
          height: (MediaQuery
              .of(context)
              .size
              .width / 100) * 10,
          width: (MediaQuery
              .of(context)
              .size
              .width / 100) * 10,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(widget.svgSrc),
        ),
        if(widget.numOfItems != 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              height: (MediaQuery
                  .of(context)
                  .size
                  .width / 100) * 5,
              width: (MediaQuery
                  .of(context)
                  .size
                  .width / 100) * 5,
              decoration: BoxDecoration(
                color: Color(0xFFFF4848),
                shape: BoxShape.circle,
                border: Border.all(width: 1.5, color: Colors.white),
              ),
              child: Center(
                child: Text("${widget.numOfItems}", style: TextStyle(
                  fontSize: (MediaQuery
                      .of(context)
                      .size
                      .width / 100) * 3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
          ),
      ],
      ),
    );
  }



}
