import 'package:booking_app/widgets/bottomnavigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                        if(snapshot.data['$userLoggedInIndex']['appointments']['$index']['appointment-status'] == false){
                          return Container();
                        }
                        else{
                          return Padding(
                            padding: EdgeInsets.all(20),
                            child: Stack(
                              children: [
                                Container(
                                  height: 300,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 12,
                                          offset: Offset(0,6),
                                        ),
                                      ]
                                  ),
                                  child: Card(
                                    elevation: 5.0,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  top: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['place-booked']}",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        child: Text("Service",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                      ),
                                      SizedBox(height: 5,),
                                      Container(
                                        child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['service-booked']}",
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
                                      SizedBox(height: 10,),
                                      Container(
                                        child: Text("Duration",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                      ),
                                      SizedBox(height: 5,),
                                      Container(
                                        child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['duration-booked']}",style: TextStyle(
                                          fontSize: 20,
                                        ),),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  right: 30,
                                  top: 240,
                                  child: Container(
                                    child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['service-price']} EGP", style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ),
                                ),
                              ],
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
}