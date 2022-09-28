import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:country_list_pick/country_list_pick.dart';

class AddCreditCard extends StatefulWidget {
  const AddCreditCard({Key? key}) : super(key: key);

  @override
  _AddCreditCardState createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {

  TextEditingController cardNumberController = TextEditingController();

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
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: TextFormField(
                          controller: cardNumberController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'MM/YY'
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
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: TextFormField(
                          controller: cardNumberController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: '123'
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
              /*
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

              */

              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: CountryListPick(

                  // if you need custome picker use this
                  /*
                  pickerBuilder: (context, CountryCode? countryCode){
                     return Row(
                       children: [
                         Image.asset(
                           countryCode?.flagUri,
                           package: 'country_list_pick',
                         ),
                         Text(countryCode?.code),
                         Text(countryCode?.dialCode),
                       ],
                     );
                   },
                  */

                  // Whether to allow the widget to set a custom UI overlay
                  useUiOverlay: true,
                  // Whether the country list should be wrapped in a SafeArea
                  useSafeArea: false,
                  theme: CountryTheme(
                    isShowFlag: true, //show flag on dropdown
                    isShowTitle: true, //show title on dropdown
                    isShowCode: true, //show code on dropdown
                    isDownIcon: true, //show down icon on dropdown
                  ),
                  initialSelection: '+20', //inital selection,
                  onChanged: (CountryCode? code) {
                    print(code?.name); //get the country name eg: Antarctica
                    print(code?.code); //get the country code like AQ for Antarctica
                    print(code?.dialCode); //get the country dial code +672 for Antarctica
                    print(code?.flagUri); //get the URL of flag. flags/aq.png for Antarctica
                  },
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
                child: TextFormField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'eg. work card'
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
                  onPressed: (){},
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


