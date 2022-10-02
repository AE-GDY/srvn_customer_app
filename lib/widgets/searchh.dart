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


    final List<Shop> searchItems =shops.where(
          (itemName) => itemName.shopName.toLowerCase().contains(
        query.toLowerCase(),
      ),
    ).toList();
    return ListView.builder(
        itemCount: searchItems.length,
        itemBuilder: (context,index){
          return Card(
              elevation: 1.0,
              child: ListTile(
                title: Text(searchItems[index].shopName,style: TextStyle(fontSize: 20)),
                subtitle: Text(searchItems[index].shopAddress,style: TextStyle(fontSize: 16)),
                trailing: Text('${(searchItems[index].shopRating)}', style: TextStyle(

                ),),
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
              )
          );
        }
    );
  }
}