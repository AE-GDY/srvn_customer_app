import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';



class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {


  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: FutureBuilder(
          future: categoryData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return const Text("Please wait");
              }
              else if(snapshot.hasData){
                return Container(
                  margin: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Options', style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),),

                      SizedBox(height: 50,),

                      Text('Payment Methods', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),),

                      SizedBox(height: 20,),


                      savedCreditCards.length > 0? Container(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: ListView.builder(
                            itemCount: savedCreditCards.length,
                            itemBuilder: (context,index){
                              return ListTile(
                                leading: Icon(Icons.credit_card ,color: Colors.blue,),
                                title: Text(savedCreditCards[index].cardNumber),
                              );
                            }),
                      ):Container(),


                      snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['cash']?ListTile(
                        leading: Icon(Icons.money_rounded,color: Colors.green,),
                        title: Text('Cash'),
                      ):savedCreditCards.length > 0?Container():Container(margin:EdgeInsets.all(0),child: Text('No Payment Methods Saved',textAlign: TextAlign.left,style: TextStyle(
                        fontSize: 16,
                      ),)),

                      SizedBox(height: 50,),

                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/add-card');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Icon(Icons.add,size: 20,color: Colors.black,),

                            Text('Add Credit Card', style: TextStyle(
                              color: Colors.black,
                            ),),
                            SizedBox(width: 10,),
                            Icon(Icons.credit_card,size: 20,color: Colors.blue,),

                          ],
                        ),
                      ),

                    ],
                  ),
                );
              }
            }
            return const CircularProgressIndicator();
          },

        ),
      ),


    );
  }
}
