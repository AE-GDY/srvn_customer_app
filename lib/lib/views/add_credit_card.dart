import 'package:booking_app/models/credit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_picker/country_picker.dart';

import '../constants.dart';

class AddCreditCard extends StatefulWidget {
  const AddCreditCard({Key? key}) : super(key: key);

  @override
  _AddCreditCardState createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();
  String? cardCountry = '';
  TextEditingController cardCVVController = TextEditingController();
  TextEditingController cardNicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Add Card', style: TextStyle(
          color: Colors.white,
        ),),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 10,),

              Text('Card Number', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: TextFormField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.credit_card,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20,),



              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expiry Date', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),

                      SizedBox(height: 10,),

                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: cardExpiryController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'MM/YY'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),

                      SizedBox(height: 10,),

                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: cardCVVController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: '123'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),



              SizedBox(height: 20,),

              Text('Country', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(height: 10,),

              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: CountryListPick(

                    appBar: AppBar(
                      backgroundColor: Colors.deepPurple,
                      title: const Text('Pick your country'),
                    ),

                    theme: CountryTheme(
                      //isShowFlag: true, //show flag on dropdown
                      /*
                      isShowTitle: true, //show title on dropdown
                      isShowCode: true, //show code on dropdown
                      isDownIcon: true,  //show down icon on dropdown
                      */
                    ),
                    initialSelection: '+20', //inital selection,
                    onChanged: (CountryCode? code) {

                      cardCountry = code?.name!;

                      print(code?.name); //get the country name eg: Antarctica
                      print(code?.code); //get the country code like AQ for Antarctica
                      print(code?.dialCode); //get the country dial code +672 for Antarctica
                      print(code?.flagUri); //get the URL of flag. flags/aq.png for Antarctica
                    },
                  ),
                ),
              ),






              SizedBox(height: 20,),

              Text('Nickname  (optional)', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: cardNicknameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'eg. work card'
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height / 5,),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: (){


                    String cardNickname = "";

                    String cardFinalFourNumbers = "";

                    if(cardNicknameController.text.isEmpty){

                      String cardNumber = cardNumberController.text;

                      int cardNumberIndex = 0;
                      while(cardNumberIndex < cardNumber.length){
                        if(cardNumberIndex >= 12){
                          cardFinalFourNumbers += cardNumber[cardNumberIndex];
                        }
                        cardNumberIndex++;
                      }

                      cardNickname = 'Visa ${cardFinalFourNumbers}';
                    }
                    else{
                      cardNickname = cardNicknameController.text;
                    }

                    CreditCard newCard = CreditCard(
                        cardCountry: cardCountry,
                        cardNumber: cardNumberController.text,
                        cardExpiry: cardExpiryController.text,
                        cvc: cardCVVController.text,
                        nickname: cardNickname,
                    );


                    savedCreditCards.add(newCard);

                    Navigator.popAndPushNamed(context, '/payment-methods');

                  },
                  child: Text('Add Card', style: TextStyle(
                    color: Colors.white,
                  ),),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}


