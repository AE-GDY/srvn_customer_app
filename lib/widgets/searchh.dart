import 'package:booking_app/constants.dart';
import 'package:flutter/material.dart';

import '../models/shop_model.dart';


class search_service extends SearchDelegate<String> {
  List<String> allServices;
  List<Shop> shops;

  search_service({required this.allServices, required this.shops});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      close(context,query);
    }, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> resultService =allServices.where(
          (service_name) => service_name.toLowerCase().contains(
        query.toLowerCase(),
      ),
    ).toList();
    return ListView.builder(
        itemCount: resultService.length,
        itemBuilder: (context,index){
          return Card(
              elevation: 20.0,
              child: ListTile(
                title: Text(resultService[index],style: TextStyle(fontSize: 20)),
                onTap:(){
                  query = resultService[index][index];
                  close(context,query);
                } ,
              )
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    //query.isEmpty ?recommendedPlaces: (searchItems = (STATEMENT))
    final List<Shop> searchItems = shops.where(
          (itemName) => itemName.shopName.toLowerCase().contains(
        query.toLowerCase(),
      ),
    ).toList();
    return Column(
      children: [

        query.isEmpty?
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(10),
              child: Text('Recommended Places',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
            ):Container(),

        SizedBox(height: 5,),
        Expanded(
          child: ListView.builder(
          itemCount: searchItems.length,
              itemBuilder: (context,index){
                return Card(
                    elevation: 1.0,
                    child: Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          height: 70,
                          child: Image.network(
                            searchItems[index].imageUrl,
                            alignment: Alignment.center,
                            fit: BoxFit.fitWidth,

                          ),
                        ),
                        title: Text(searchItems[index].shopName,style: TextStyle(fontSize: 20)),
                        subtitle: Text('${searchItems[index].shopCategory}, ${searchItems[index].shopAddress}',style: TextStyle(fontSize: 16)),
                        trailing: Container(
                          width: MediaQuery.of(context).size.width/6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.star, color: Color(0xffFF8573),),
                                  Text('${(searchItems[index].shopRating)}', style: TextStyle(
                                    color: Color(0xffFF8573),
                                  ),),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Text('${(searchItems[index].shopReviewAmount)} reviews', style: TextStyle(
                                color: Colors.black,
                              ),),
                            ],
                          ),
                        ),
                        onTap:(){


                          currentCategory = searchItems[index].shopCategory;
                          currentShopIndex = searchItems[index].shopIndex;
                          currentShop = searchItems[index].shopName;
                          currentAddress = searchItems[index].shopAddress;

                          print(currentCategory);
                          print(currentShopIndex);

                          // query = searchItems[index].shopName;
                          //close(context,query);
                          Navigator.popAndPushNamed(context, '/currentshop');
                        } ,
                      ),
                    )
                );
              }
          ),
        ),

      ],
    );
  }
}