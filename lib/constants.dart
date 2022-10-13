import 'package:booking_app/models/barbershop.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/credit_card.dart';



// AFTER

List<String> months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
List<String> monthsFull = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];



int globalDay = 0;
String globalDayWords = '';
int globalYear = 0;
String globalTime = '';


String currentCategory = '';
int currentBarberTimingIdx = 0;
//int globalShopIndex = 0;


//USER INFO
String userEmail = '';
String userPassword = '';
bool loggedIn = false;
bool onLoginScreen = true;
int userLoggedInIndex = 0;
String userLoggedInEmail = '';
String userLoggedInName = '';


// BEFORE
const kPurple = Color(0xFF6F51FF);
const kYellow = Color(0xFFFFAD03);
const kGreen = Color(0xFF22B274);
const kPink = Color(0xFFEB1E79);
const kIndigo = Color(0xFF000A45);
const kBlack = Color(0xFF4C4C4C);
const kGrey = Color(0xFFACACAC);

DateTime timePicked = DateTime.now();
var appointmentAmount = 0;
var onBarberShop = false;
var onSaloonShop = false;
var onSpaShop = false;
var onGymShop = false;
var onCalender = false;
var barberShopIndex = 0;
var currentEmployeeIndex = 0;
var currentServiceIndex = 0;
var currentMembershipIndex = 0;
var currentShopIndex = 0;
var serviceBooked;
var serviceDuration;
var globalServicePrice;
var serviceProvider;
var activeIndex = 0;
dynamic globalServiceList;
bool onShopList = false;
// This stores current shop.
dynamic globalShop = bestList[0];
var employeeCount = 0;
var currentTime = 0;

final kHintTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(

  borderRadius: BorderRadius.circular(10.0),
  /*
    boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
  */
);

bool hasInternet = false;


// STORES APPOINTMENT LIST
List<Map<dynamic, dynamic>> appointmentList = [

];

List<Map<String,dynamic>> categories = [
  {"icon" : "assets/all_images/Bell.svg", "text": "Salons"},
  {"icon" : "assets/all_images/Bell.svg", "text": "Barbershops"},
  {"icon" : "assets/all_images/Bell.svg", "text": "Spas"},
  {"icon" : "assets/all_images/Bell.svg", "text": "Personal Trainers"},
  {"icon" : "assets/all_images/Bell.svg", "text": "Paddle Tennis"},
];

var timings = [
  '9:00',
  '9:15',
  '9:30',
  '9:45',
  '10:00',
  '10:15',
  '10:30',
  '10:45',
  '11:00',
  '11:15',
  '11:30',
  '11:45',
  '12:00',
];

var kTitleStyle = GoogleFonts.roboto(
  color: kBlack,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);
var kSubtitleStyle = GoogleFonts.roboto(
  color: kGrey,
  fontSize: 14.0,
);
var kTitleItem = GoogleFonts.roboto(
  color: kBlack,
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
);
var kSubtitleItem = GoogleFonts.roboto(
  color: kGrey,
  fontSize: 12.0,
);
var kHintStyle = GoogleFonts.roboto(
  color: kGrey,
  fontSize: 12.0,
);

bool globalServiceLinked = false;
int globalMinuteGap = 0;
String globalMaxAmount = '';




int startYear = 0;
int startMonth = 0;
int startDay = 0;
int startHour = 0;
int startMinutes = 0;

int endYear = 0;
int endMonth = 0;
int endDay = 0;
int endHour = 0;
int endMinutes = 0;

int endHourActual = 0;
int startHourActual = 0;


String currentShop = '';
String currentAddress = '';


bool isPackage = false;

String globalStartTime = "";
String globalEndTime = "";

String typeOfItemSelected = "Services";

List<CreditCard> savedCreditCards = [];

CreditCard? cardSelected;

bool cashSelected = false;
bool nothingSelected = true;


bool bookingClicked = false;


bool viewedNotification = false;
bool onSettings = false;
bool onMembership = false;