import 'package:booking_app/constants.dart';
import 'package:booking_app/widgets/bottomnavigator.dart';
import 'package:flutter/material.dart';


var mainSettings = [
  "Gift Cards",
  "Account and Settings",
  "Reviews",
  "Payments",
  "Feedback and Support",
  "About Servnn",
  "Log in",
];

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar2(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text("Profile",style: TextStyle(
            color: Colors.black,
          ),),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index){
              return Card(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {

                    });

                    if(mainSettings[index] == 'Log in'){

                      if(loggedIn){
                        loggedIn = false;
                      }

                      Navigator.pushNamed(context, '/login');
                    }
                  },
                  child: ListTile(
                    title: Text((mainSettings[index] == 'Log in' && !loggedIn)?"${mainSettings[index]}":
                      (mainSettings[index] == 'Log in' && loggedIn)?'Log out':"${mainSettings[index]}", style: TextStyle(
                      fontSize: 20,
                    ),),
                    trailing: Icon(Icons.keyboard_arrow_right),),
                ),
              );
            })
    );
  }
}
