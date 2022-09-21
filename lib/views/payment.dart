import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'home.dart';


class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cscController = TextEditingController();


  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        title: Text("Payment",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 500,
          height: 1000,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.all(15),
                child: Text("Card Details",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Center(
                child: Container(
                  width: 400,
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Card(
                    elevation: 10.0,
                    child: Container(
                      width: 400,
                      height: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //FROM HERE\
                          SizedBox(height: 20,),
                          Container(
                            height: 50,
                            width: 400,
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: "Card Holder Name",
                                //hintText: "Card Holder Name",
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 50,
                            width: 400,
                            child: TextField(
                              controller: numberController,
                              decoration: InputDecoration(
                                labelText: "Card Number",
                                //hintText: "Card Number",
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: 400,
                            height: 100,
                            child: Row(
                              children: [
                                Container(
                                  width: 200,
                                  height: 50,

                                  child: Text("Payment Method", style: TextStyle(
                                    fontSize: 18,
                                  ),),
                                ),
                                Container(
                                  width: 150,
                                  height: 100,
                                  child: Image.asset(
                                    "assets/all_images/paymentMs.JPG",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 400,
                            child: Row(
                              children: [
                                Container(
                                  child: TextField(
                                    controller: expiryController,
                                    decoration: InputDecoration(
                                        labelText: "Expires",
                                        hintText: "MM/YY"
                                    ),
                                  ),
                                  width: 150,
                                  height: 50,
                                ),
                                SizedBox(width: 60,),
                                Container(
                                  child: TextField(
                                    controller: cscController,
                                    decoration: InputDecoration(
                                      labelText: "CSC",
                                      hintText: "3 digits",
                                    ),
                                  ),
                                  width: 150,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Center(
                child: FutureBuilder(
                  future: Future.wait([categoryData(),userData()]),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasError){
                        return const Text("There is an error");
                      }
                      else if(snapshot.hasData){
                        return Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async {

                              print("1");
                              await databaseService.updateAppointmentStats(
                                currentCategory,
                                currentShopIndex,
                                months[startMonth-1],
                                snapshot.data[0]['$currentShopIndex']['appointments']['appointment-amount']+1,
                              );


                              print("2");

                              await databaseService.addAppointment(
                                globalDayWords,
                                snapshot.data[1]['$userLoggedInIndex']['full-name'],
                                snapshot.data[1]['$userLoggedInIndex']['email'],
                                currentCategory,
                                currentShopIndex,
                                snapshot.data[0]['$currentShopIndex']['appointments']['appointment-amount']+1,
                                snapshot.data[0]['$currentShopIndex']['appointments']['incomplete']+1,
                                startYear,
                                startMonth,
                                startDay,
                                startHour,
                                startHourActual,
                                startMinutes,
                                startYear,
                                startMonth,
                                startDay,
                                endHour,
                                endHourActual,
                                endMinutes,
                                'blank',
                                serviceBooked,
                                globalServicePrice,
                                globalServiceLinked?"none":snapshot.data[0]['$currentShopIndex']['staff-members']['$currentEmployeeIndex']['member-name'],
                                globalServiceLinked?"none":snapshot.data[0]['$currentShopIndex']['staff-members']['$currentEmployeeIndex']['member-role'],
                                'Services',
                                serviceDuration,
                                snapshot.data[1]["$userLoggedInIndex"]['appointment-amount']+1,
                                globalStartTime,
                                globalEndTime,
                              );

                              print("3");



                              await databaseService.updateUserAppointments(
                                  snapshot.data[1]["$userLoggedInIndex"]['appointment-amount']+1,
                                  userLoggedInIndex,
                                  "${onCalender?globalDay:DateTime.now().day} ${onCalender?DateFormat.LLLL().format(timePicked):DateFormat.LLLL().format(DateTime.now())} ${onCalender?globalYear:DateTime.now().year}, $globalTime",
                                  serviceBooked,
                                  currentShop,
                                  serviceDuration,
                                  globalServiceLinked?"none":snapshot.data[0]['$currentShopIndex']['staff-members']['$currentEmployeeIndex']['member-name'],
                                  globalServicePrice,
                              );

                              print("4");

                              int clientIndex = 0;
                              bool clientFound = false;
                              while(clientIndex <= snapshot.data[0]['$currentShopIndex']['client-amount']){

                                if(snapshot.data[0]['$currentShopIndex']['clients']['$clientIndex']['email'] == snapshot.data[1]['$userLoggedInIndex']['email']){
                                  clientFound = true;
                                  break;
                                }

                                clientIndex++;
                              }

                              print("5");

                              if(!clientFound){
                                await databaseService.addClient(
                                  currentCategory,
                                  currentShopIndex,
                                  snapshot.data[0]['$currentShopIndex']['client-amount']+1,
                                  snapshot.data[1]['$userLoggedInIndex']['full-name'],
                                  snapshot.data[1]['$userLoggedInIndex']['email'],
                                );
                              }
                              Navigator.pushNamed(context, '/booked');
                            },
                            child: Text("Proceed",style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
                        );
                      }
                    }
                    return const Text("Please wait");
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
