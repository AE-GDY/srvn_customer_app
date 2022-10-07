import 'package:booking_app/views/add_credit_card.dart';
import 'package:booking_app/views/appointments.dart';
import 'package:booking_app/views/bookedappointment.dart';
import 'package:booking_app/views/bookingscreen.dart';
import 'package:booking_app/views/currentshopview.dart';
import 'package:booking_app/views/explore.dart';
import 'package:booking_app/views/home.dart';
import 'package:booking_app/views/login.dart';
import 'package:booking_app/views/payment-methods.dart';
import 'package:booking_app/views/payment.dart';
import 'package:booking_app/views/profile.dart';
import 'package:booking_app/views/shoplist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';




Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
          title: 'Flutter Barbershop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme:  GoogleFonts.latoTextTheme(),
          ),
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/' : (context) => Home(),
            '/login': (context) => LoginScreen(),
            '/currentshop' : (context) => CurrentShop(),
            '/bookingscreen': (context) => BarberTime(),
            '/appointments': (context) => AppointmentList(),
            '/shoplist': (context) => shopList(),
            '/booked' : (context) => SuccessfulBooking(),
            '/explore': (context) => Explore(),
            '/profile': (context) => Profile(),
            '/payment': (context) => Payment(),
            '/payment-methods': (context) => PaymentMethods(),
            '/add-card': (context) => AddCreditCard(),
          }
      ),
    );
  }
}