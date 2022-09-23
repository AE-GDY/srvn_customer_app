import 'package:flutter/material.dart';


class search_service extends SearchDelegate<String> {
  List<String> allServices;
  List<String> servicesSuggestion;

  search_service({required this.allServices, required this.servicesSuggestion});

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
    final List<String> resultServicesuggestion =servicesSuggestion.where(
          (service_namesuggestion) => service_namesuggestion.toLowerCase().contains(
        query.toLowerCase(),
      ),
    ).toList();
    return ListView.builder(
        itemCount: resultServicesuggestion.length,
        itemBuilder: (context,index){
          return Card(
              elevation: 20.0,
              child: ListTile(
                title: Text(resultServicesuggestion[index],style: TextStyle(fontSize: 20)),
                onTap:(){
                  query = resultServicesuggestion[index];
                  close(context,query);
                } ,
              )
          );
        }
    );
  }
}