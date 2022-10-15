import 'package:booking_app/widgets/bottomnavigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';


class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: NavigationBar2(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text("Appointments",style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: userData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return const Text("There is an error");
            }
            else if(snapshot.hasData){
              return Container(
                child: ListView.builder(
                    itemCount: snapshot.data['$userLoggedInIndex']['appointment-amount']+1,
                    itemBuilder: (context, index){



                      if(loggedIn){


                        int currentHour = DateTime.now().hour;
                        int currentMinute = DateTime.now().minute;

                        String currentTime = "";
                        String end = "";
                        String minute = "";

                        if(currentHour >= 12){
                          if(currentHour != 12){
                            currentHour -= 12;
                          }
                          end = 'PM';
                        }
                        else{
                          end = 'AM';
                        }

                        if(currentMinute == 0){
                          minute = "00";
                        }
                        else{
                          minute = '$currentMinute';
                        }

                        currentTime = '$currentHour:$currentMinute $end';


                        bool currentTimeGreaterThanAppointmentTime = false;

                        if(DateTime.now().day == snapshot.data['$userLoggedInIndex']['appointments']['$index']['start-day']
                        &&DateTime.now().month == snapshot.data['$userLoggedInIndex']['appointments']['$index']['start-month']
                        && DateTime.now().year == snapshot.data['$userLoggedInIndex']['appointments']['$index']['start-year']){


                          print('CURRENT TIME: $currentTime');
                          print('END TIME: ${snapshot.data['$userLoggedInIndex']['appointments']['$index']['end-time']}');

                          currentTimeGreaterThanAppointmentTime = isGreater(currentTime,snapshot.data['$userLoggedInIndex']['appointments']['$index']['end-time']);

                        }
                        else if(DateTime.now().day > snapshot.data['$userLoggedInIndex']['appointments']['$index']['start-day']
                            &&DateTime.now().month >= snapshot.data['$userLoggedInIndex']['appointments']['$index']['start-month']
                            && DateTime.now().year >= snapshot.data['$userLoggedInIndex']['appointments']['$index']['start-year']){
                          currentTimeGreaterThanAppointmentTime = true;
                        }




                        if(snapshot.data['$userLoggedInIndex']['appointments']['$index']['appointment-status'] == false){
                          return Container();
                        }
                        else if(currentTimeGreaterThanAppointmentTime){
                          return Container();
                        }
                        else{
                          return Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple,width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['place-booked']}",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                        ),


                                        Container(
                                          width: 100,
                                          height: 80,
                                          child: Image.network(
                                            snapshot.data['$userLoggedInIndex']['appointments']['$index']['place-logo'],
                                            alignment: Alignment.center,
                                            fit: BoxFit.fitWidth,

                                          ),
                                        ),

                                        /*
                                        FutureBuilder(
                                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                            if(snapshot.connectionState == ConnectionState.done){
                                              if(snapshot.hasError){
                                                return const Text("Please wait");
                                              }
                                              else if(snapshot.hasData){
                                                return Image.network(
                                                  snapshot.data['$currentShopIndex']['images']['${-1}'],
                                                  width: MediaQuery.of(context).size.width,
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.fitWidth,
                                                );
                                              }
                                            }
                                            return const CircularProgressIndicator();
                                          },

                                        ),
                                        */

                                      ],
                                    ),
                                    Container(
                                      child: Text("Service",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['service-booked']}, ${snapshot.data['$userLoggedInIndex']['appointments']['$index']['duration-booked']}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      child: Text("Date",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['date-booked']}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      child: Text("Time",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['start-time']}-${snapshot.data['$userLoggedInIndex']['appointments']['$index']['end-time']}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),),
                                    ),
                                    SizedBox(height: 10,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [


                                        snapshot.data['$userLoggedInIndex']['appointments']['$index']['pending-confirmation'] ?
                                        Container(
                                          width: 180,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.deepOrange,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                            onPressed: (){},
                                            child: Text('Pending Confirmation',style: TextStyle(
                                              color: Colors.white,
                                            ),),
                                          ),
                                        ):Container(
                                          width: 180,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                            onPressed: (){},
                                            child: Text('Confirmed',style: TextStyle(
                                              color: Colors.white,
                                            ),),
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['service-price']} EGP", style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      else{
                        return Container();
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


  bool isGreater(String firstTime, String secondTime){

    String firstTimeEnd = getAMorPM(firstTime);
    String secondTimeEnd  = getAMorPM(secondTime);

    String firstTimeHour = getHour(firstTime);
    String secondTimeHour = getHour(secondTime);

    int firstTimeHourInt = int.parse(firstTimeHour);
    int secondTimeHourInt = int.parse(secondTimeHour);

    String firstTimeMinute = getMinute(firstTime);
    String endTimeMinute = getMinute(secondTime);

    int firstTimeMinuteInt = int.parse(firstTimeMinute);
    int secondTimeMinuteInt = int.parse(endTimeMinute);

    if(firstTimeEnd == 'AM' && firstTimeHourInt == 12){
      firstTimeHourInt = 0;
    }
    if(secondTimeEnd == 'AM' && secondTimeHourInt == 12){
      secondTimeHourInt = 0;
    }

    if(firstTimeEnd == 'PM'){
      if(firstTimeHourInt != 12){
        firstTimeHourInt += 12;
      }
    }
    if(secondTimeEnd == 'PM'){
      if(secondTimeHourInt != 12){
        secondTimeHourInt += 12;
      }
    }

    print('first time hour: $firstTimeHourInt');
    print('second time hour: $secondTimeHourInt');

    if(firstTimeHourInt == secondTimeHourInt){
      if(firstTimeMinuteInt >= secondTimeMinuteInt){
        print('1');
        return true;
      }
    }
    else if(firstTimeHourInt > secondTimeHourInt){
      print('2');
      return true;
    }
    return false;
  }

  String getAMorPM(String time){

    // WHERE THE MINUTE WILL BE STORES
    String output = "";

    // CHARACTER INDEX IN TIME STRING (EXAMPLE "10:00 PM" IS TIME STRING)
    int charIndex = 0;

    // CHECKS IF "charIndex" IS AT THE FIRST NUMBER OF THE MINUTE
    bool reachedLetter = false;

    while(charIndex < time.length){

      if(time[charIndex] == 'A' || time[charIndex] == 'P'){
        reachedLetter = true;
      }

      if(reachedLetter){
        output += time[charIndex];
      }

      charIndex++;
    }

    return output;
  }

  // GETS MINUTE FROM INPUT STRING
  String getMinute(String time){

    // WHERE THE MINUTE WILL BE STORES
    String minute = "";

    // CHARACTER INDEX IN TIME STRING (EXAMPLE "10:00 PM" IS TIME STRING)
    int charIndex = 0;

    // CHECKS IF "charIndex" IS AT THE FIRST NUMBER OF THE MINUTE
    bool reachedMinute = false;

    while(charIndex < time.length){


      // IF "reachedMinute" THEN ADD THE CURRENT CHARACTER TO THE MINUTE STRING
      if(reachedMinute){
        minute += time[charIndex];
      }

      // IF CURRENT CHARACTER IS ':', THIS MEANS NEXT CHARACTER IS THE FIRST NUMBER OF THE MINUTE
      if(time[charIndex] == ':'){
        reachedMinute = true;
      }

      // IF CURRENT CHARACTER IS " " (A SPACE), THEN THE LAST
      // NUMBER OF THE MINUTE IS DONE SO RETURN THE MINUTE
      else if(time[charIndex] == " "){
        return minute;
      }

      charIndex++;
    }

    return minute;
  }


  // GETS HOUR FROM TIME STRING
  String getHour(String time){

    // WHERE THE HOUR WILL BE STORED
    String hour = "";

    // CHARACTER INDEX IN TIME STRING (EXAMPLE "10:00 PM" IS TIME STRING)
    int charIndex = 0;

    while(charIndex < time.length){

      if(time[charIndex] == ':'){
        return hour;
      }
      else{
        hour += time[charIndex];
      }

      charIndex++;
    }

    return hour;
  }

}