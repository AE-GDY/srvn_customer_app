import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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



  int currentRating = 0;
  TextEditingController reviewController = TextEditingController();

  List<bool> starsSelected = [false,false,false,false,false];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalRequiresConfirmation?Colors.deepOrange:Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: MediaQuery.of(context).size.height/5,),

              typeOfItemSelected != 'Memberships'?Text(globalRequiresConfirmation?"Pending Confirmation":"Appointment Confirmed!", style: TextStyle(
                fontSize: 30,
                color: globalRequiresConfirmation?Colors.white:Colors.black,
                fontWeight: FontWeight.bold,
              ),):Text("Membership Purchased!", style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(height: 10,),

              Icon(globalRequiresConfirmation?Icons.calendar_today_rounded:Icons.check_circle,
                color: globalRequiresConfirmation?Colors.white:Colors.green,
                size: 150,
              ),

              SizedBox(height: 40,),

              typeOfItemSelected != 'Memberships'?Text("Service",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),):Text("Membership",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),

              SizedBox(height: 5,),
              Text("$serviceBooked",
                style: TextStyle(
                  fontSize: 18,
                  color: globalRequiresConfirmation?Colors.white:Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),),

              SizedBox(height: 10,),

              typeOfItemSelected != 'Memberships'?Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Date",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 5,),
                  Text("${onCalender?globalDay:DateTime.now().day} ${onCalender?DateFormat.LLLL().format(timePicked):DateFormat.LLLL().format(DateTime.now())} ${onCalender?globalYear:DateTime.now().year}",
                    style: TextStyle(
                      fontSize: 18,
                      color: globalRequiresConfirmation?Colors.white:Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),),

                  SizedBox(height: 10,),

                  Text("Time",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),

                  Text("$globalTime",
                    style: TextStyle(
                      fontSize: 18,
                      color: globalRequiresConfirmation?Colors.white:Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),),
                ],
              ):Container(),


              Expanded(child: Container()),
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
                          color: globalRequiresConfirmation?Colors.white:Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                          onPressed: (){

                            globalRequiresConfirmation = false;
                            bookingClicked = false;
                            Navigator.pushNamed(context, '/');

                          },
                          child: Text("Ok, got it!", style: TextStyle(
                            color: globalRequiresConfirmation?Colors.black:Colors.white,
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
        ),
      ),
    );

  }
}



