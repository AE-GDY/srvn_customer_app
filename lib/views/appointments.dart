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
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5.0,
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
                                      children: [
                                        Container(
                                          child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['place-booked']}",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),),
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

                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: Text("${snapshot.data['$userLoggedInIndex']['appointments']['$index']['service-price']} EGP", style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),),
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
}