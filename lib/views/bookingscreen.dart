import 'package:booking_app/models/barbershop.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class BarberTime extends StatefulWidget {

  GlobalKey _key = GlobalKey();

  var currentHeight = 160.0;

  @override
  State<StatefulWidget> createState() => _BarberTimeState();
}

class _BarberTimeState extends State<BarberTime> {


  Future<Map<String, dynamic>?> categoryData() async {
    return (await FirebaseFirestore.instance.collection('shops').
    doc(currentCategory).get()).data();
  }

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }


  CalendarFormat format = CalendarFormat.week;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  int mostAvailableEmployee = 0;

  dynamic currentDayTimings = {};
  dynamic bookingsPerSlot = {};
  int currentMinuteGap = 0;



  bool addedCreditCard = false;

  List<bool> passedTimeStatuses = [];
  List<bool> isBlocked = [];

  List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  List<int> hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  final dateFormat = DateFormat('EEEE yyyy-MMMM-dd');
  DateTime _chosenDate = DateTime.now();


  bool initialSetter = false;
  String currentDateInWords = '';
  String currentDayOfWeek = '';


  DatabaseService databaseService = DatabaseService();


  @override
  Widget build(BuildContext context) {
    if (!initialSetter) {

      if(savedCreditCards.length > 0){
        nothingSelected = false;
      }

      bookingClicked = false;

      currentDateInWords = dateFormat.format(_chosenDate);

      int letterIdx = 0;
      while (letterIdx < currentDateInWords.length) {
        if (currentDateInWords[letterIdx] != ' ') {
          currentDayOfWeek += currentDateInWords[letterIdx];
        }
        else {
          break;
        }
        letterIdx++;
      }
      print("CURRENT DAY: $currentDayOfWeek");
      initialSetter = true;
    }

    bool initialCalendarSetup = true;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: FutureBuilder(
          future: categoryData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("There is an error");
              }
              else if (snapshot.hasData) {



                if(typeOfItemSelected == 'Services'){
                  if (initialCalendarSetup) {
                    String from = "";
                    String to = "";
                    int minuteGap = 0;

                    if (globalServiceLinked) {
                      from = snapshot.data['$currentShopIndex']['business-hours'][currentDayOfWeek]['from'];
                      to = snapshot.data['$currentShopIndex']['business-hours'][currentDayOfWeek]['to'];
                    }
                    else {
                      int employeeIndex = 0;

                      if(currentEmployeeIndex == 0){
                        employeeIndex = mostAvailableEmployee;
                      }
                      else{
                        employeeIndex = currentEmployeeIndex;
                      }

                      from = snapshot.data['$currentShopIndex']['staff-members']['$employeeIndex']['member-timings'][currentDayOfWeek]['from'];
                      to = snapshot.data['$currentShopIndex']['staff-members']['$employeeIndex']['member-timings'][currentDayOfWeek]['to'];
                    }

                    minuteGap = snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['minute-gap'];

                    currentMinuteGap = minuteGap;

                    currentDayTimings = createTimeData(from, to, minuteGap);
                    initialCalendarSetup = false;
                  }

                  return Container(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        buildStaffMembers(snapshot),
                        Divider(
                          height: 10,
                          color: Colors.black54,
                          thickness: 1,
                          //indent: 20,
                          //endIndent: 20,
                        ),
                        SizedBox(
                          height: widget.currentHeight,
                          child: TableCalendar(
                            key: widget._key,
                            focusedDay: selectedDay,
                            firstDay: DateTime(1990),
                            lastDay: DateTime(2050),
                            calendarFormat: format,
                            daysOfWeekVisible: true,
                            calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              todayTextStyle: TextStyle(color: Colors.black),
                              selectedTextStyle: TextStyle(color: Colors.white),
                              todayDecoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                //borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: true,
                              titleCentered: true,
                              formatButtonShowsNext: false,
                            ),
                            selectedDayPredicate: (DateTime date) {
                              return isSameDay(selectedDay, date);
                            },
                            onDaySelected: (DateTime selectDay, DateTime focusDay) {
                              setState(() {
                                //print(selectedDay.);
                                if ((focusDay.day >= DateTime.now().day && focusDay.month == DateTime.now().month) || focusDay.month > DateTime.now().month) {
                                  setState(() {
                                    currentDateInWords =
                                        dateFormat.format(focusDay);
                                    currentDayOfWeek = '';
                                    int letterIdx = 0;
                                    while (letterIdx < currentDateInWords.length) {
                                      if (currentDateInWords[letterIdx] != ' ') {
                                        currentDayOfWeek +=
                                        currentDateInWords[letterIdx];
                                      }
                                      else {
                                        break;
                                      }
                                      letterIdx++;
                                    }

                                    onCalender = true;
                                    selectedDay = selectDay;
                                    focusedDay = focusDay;
                                    timePicked = selectedDay;

                                    print("CURRENT DAY: ${selectedDay.day}");

                                    String from = "";
                                    String to = "";
                                    int minuteGap = 0;

                                    if (globalServiceLinked) {
                                      from = snapshot.data['$currentShopIndex']['business-hours'][currentDayOfWeek]['from'];
                                      to = snapshot.data['$currentShopIndex']['business-hours'][currentDayOfWeek]['to'];
                                    }
                                    else {
                                      int employeeIndex = 0;

                                      if(currentEmployeeIndex == 0){
                                        employeeIndex = mostAvailableEmployee;
                                      }
                                      else{
                                        employeeIndex = currentEmployeeIndex;
                                      }

                                      from = snapshot.data['$currentShopIndex']['staff-members']['$employeeIndex']['member-timings'][currentDayOfWeek]['from'];
                                      to = snapshot.data['$currentShopIndex']['staff-members']['$employeeIndex']['member-timings'][currentDayOfWeek]['to'];
                                    }

                                    minuteGap = snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['minute-gap'];
                                    currentMinuteGap = minuteGap;


                                    currentDayTimings = {};
                                    currentDayTimings = createTimeData(from, to, minuteGap);
                                  });
                                }
                              });
                            },
                            onFormatChanged: (CalendarFormat _format) {
                              setState(() {
                                format = _format;
                                print(format.toString());
                                setState(() {
                                  if (format == CalendarFormat.week) {
                                    widget.currentHeight = 150;
                                  }
                                  else if (format == CalendarFormat.twoWeeks) {
                                    widget.currentHeight = 350;
                                  }
                                  else if (format == CalendarFormat.month) {
                                    widget.currentHeight = 400;
                                  }
                                });
                                //   print(widget._key!.currentContext!.size!.height);
                              });
                            },
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.black54,
                          thickness: 1,
                          //indent: 20,
                          //endIndent: 20,
                        ),
                        //SizedBox(height: 40,),


                        FutureBuilder(
                          future: categoryData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text("There is an error");
                              }
                              else if (snapshot.hasData) {
                                List<bool> conflictingTimes = [];
                                passedTimeStatuses = [];

                                int timingIndex = 0;

                                while (timingIndex < currentDayTimings.length) {
                                  conflictingTimes.add(false);
                                  timingIndex++;
                                }


                                // INITIALIZES THE BOOKINGS MAP
                                int appointmentIndex = 0;
                                while (appointmentIndex <= snapshot.data['$currentShopIndex']['appointments']['appointment-amount']) {
                                  // START TIME STORED FROM DATABASE IN VARIABLE
                                  String startTime = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['start-time'];

                                  // END TIME
                                  String endTime = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['end-time'];


                                  String staffName = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['member-name'];

                                  bookingsPerSlot['$startTime-$endTime-$staffName'] =
                                  0;

                                  appointmentIndex++;
                                }


                                // FILLS THE BOOKINGS MAP WITH THE AMOUNT OF APPOINTMENTS PER TIMING
                                appointmentIndex = 0;
                                while (appointmentIndex <= snapshot.data['$currentShopIndex']['appointments']['appointment-amount']) {
                                  // START TIME STORED FROM DATABASE IN VARIABLE
                                  String startTime = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['start-time'];

                                  // END TIME
                                  String endTime = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['end-time'];


                                  String staffName = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['member-name'];

                                  int currentAmountOfBookings = bookingsPerSlot['$startTime-$endTime-$staffName'];
                                  currentAmountOfBookings++;
                                  bookingsPerSlot['$startTime-$endTime-$staffName'] = currentAmountOfBookings;

                                  appointmentIndex++;
                                }


                                int employeeIndex = 0;

                                if(currentEmployeeIndex == 0){
                                  employeeIndex = mostAvailableEmployee;
                                }
                                else{
                                  employeeIndex = currentEmployeeIndex;
                                }


                                timingIndex = 0;
                                while (timingIndex < currentDayTimings.length) {
                                  bool isConflicting = false;
                                  appointmentIndex = 0;
                                  while (appointmentIndex <= snapshot.data['$currentShopIndex']['appointments']['appointment-amount']) {
                                    isConflicting = isInConflict(
                                        appointmentIndex,
                                        serviceBooked,
                                        globalServiceLinked ? "none" : snapshot.data['$currentShopIndex']['staff-members']['$employeeIndex']['member-name'],
                                        selectedDay.day,
                                        selectedDay.month,
                                        selectedDay.year,
                                        currentDayTimings['$timingIndex'],
                                        snapshot
                                    );

                                    if (isConflicting) {
                                      conflictingTimes[timingIndex] = true;
                                      break;
                                    }

                                    appointmentIndex++;
                                  }
                                  timingIndex++;
                                }

                                timingIndex = 0;
                                while(timingIndex < currentDayTimings.length){

                                  String currentTime = currentDayTimings['$timingIndex'];
                                  String currentHourString = getHour(currentTime);

                                  int currentHour = int.parse(getHour(currentHourString));
                                  String end = getAMorPM(currentDayTimings['$timingIndex']);

                                  String minuteString = getMinute(currentDayTimings['$timingIndex']);
                                  int minute = 0;

                                  if(minuteString != '00'){
                                    minute = int.parse(minuteString);
                                  }

                                  if(end == 'PM'){
                                    if(currentHour < 12){
                                      currentHour += 12;
                                    }
                                  }
                                  else{
                                    if(currentHour == 12){
                                      currentHour -= 12;
                                    }
                                  }


                                  bool timePassed = passedTime(currentHour, minute, selectedDay.day, selectedDay.month, selectedDay.year);
                                  passedTimeStatuses.add(timePassed);

                                  timingIndex++;
                                }


                                return Container(
                                  height: 50,
                                  margin: EdgeInsets.only(right: 20),
                                  child: ListView.builder(
                                    //timingAmount
                                    itemCount: currentDayTimings.length,
                                    scrollDirection: Axis.horizontal,
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {

                                      print('INDEX: $index');

                                      print(conflictingTimes[index]);
                                      print('');


                                      if (conflictingTimes[index] || passedTimeStatuses[index]) {
                                        return Container();
                                      }
                                      else {
                                        return MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              currentTime = index;
                                            });
                                          },
                                          child: timingsData(
                                            currentDayTimings['$index'],
                                            index,
                                            snapshot,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }
                            }
                            return const Text("Please wait");
                          },

                        ),

                        SizedBox(height: 30,),


                        Container(
                          height: MediaQuery.of(context).size.height/3,
                          child: Card(
                            elevation: 10.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text('Payment Method', style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: (){

                                        if(loggedIn){
                                          Navigator.pushNamed(context, '/add-card');
                                        }
                                        else{
                                          Navigator.pushNamed(context, '/login');
                                        }

                                      },
                                      child: Row(
                                        children: [

                                          Icon(Icons.add,size: 20,color: Colors.black,),

                                          Text('Add Credit Card', style: TextStyle(
                                            color: Colors.black,
                                          ),),


                                        ],
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),

                                SizedBox(height: 10,),

                                FutureBuilder(
                                  future: categoryData(),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                    if(snapshot.connectionState == ConnectionState.done){
                                      if(snapshot.hasError){
                                        return const Text("There is an error");
                                      }
                                      else if(snapshot.hasData){

                                        if(snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['both'] == false && snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['cash'] == true){
                                          cashSelected = true;

                                          return Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: TextButton(
                                              onPressed: (){

                                              },
                                              child: ListTile(
                                                leading: Icon(Icons.money_rounded,color: Colors.green,),
                                                title: Text('Cash'),
                                              ),
                                            ),
                                          );
                                        }

                                        else if(nothingSelected){

                                          if(snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['both'] || snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['cash']){


                                            print('BOTH OR CASH');

                                            cashSelected = true;

                                            return Container(
                                              margin: EdgeInsets.only(right: 10),
                                              child: TextButton(
                                                onPressed: (){

                                                  if(loggedIn){
                                                    Navigator.pushNamed(context, '/payment-methods');
                                                  }
                                                  else{
                                                    Navigator.pushNamed(context, '/login');
                                                  }
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.money_rounded,color: Colors.green,),
                                                  title: Text('Cash'),
                                                  trailing: Icon(Icons.arrow_downward,color: Colors.black,),
                                                ),
                                              ),
                                            );
                                          }
                                          else{
                                            if(cashSelected){
                                              return Container(
                                                margin: EdgeInsets.only(right: 10),
                                                child: TextButton(
                                                  onPressed: (){

                                                    if(loggedIn){
                                                      Navigator.pushNamed(context, '/payment-methods');
                                                    }
                                                    else{
                                                      Navigator.pushNamed(context, '/login');
                                                    }

                                                  },
                                                  child: ListTile(
                                                    leading: Icon(Icons.money_rounded,color: Colors.green,),
                                                    title: Text('Cash'),
                                                    trailing: Icon(Icons.arrow_downward,color: Colors.black,),
                                                  ),
                                                ),
                                              );
                                            }
                                            else{

                                              return Container(
                                                margin: EdgeInsets.only(right: 30),
                                                child: TextButton(
                                                  onPressed: (){
                                                    if(loggedIn){
                                                      Navigator.pushNamed(context, '/payment-methods');
                                                    }
                                                    else{
                                                      Navigator.pushNamed(context, '/login');
                                                    }
                                                  },
                                                  child: ListTile(
                                                    leading: Icon(Icons.credit_card ,color: Colors.blue,),
                                                    title: savedCreditCards.length > 0?Text(savedCreditCards[0].nickname):Text('No Credit Card Added'),
                                                    trailing: Icon(Icons.arrow_right,color:Colors.black,),
                                                  ),
                                                ),
                                              );
                                            }

                                          }
                                        }
                                        else{

                                          if(cashSelected){
                                            return Container(
                                              margin: EdgeInsets.only(right: 10),
                                              child: TextButton(
                                                onPressed: (){
                                                  if(loggedIn){
                                                    Navigator.pushNamed(context, '/payment-methods');
                                                  }
                                                  else{
                                                    Navigator.pushNamed(context, '/login');
                                                  }
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.money_rounded,color: Colors.green,),
                                                  title: Text('Cash'),
                                                  trailing: Icon(Icons.arrow_downward,color: Colors.black,),
                                                ),
                                              ),
                                            );
                                          }
                                          else{
                                            return Container(
                                              margin: EdgeInsets.only(right: 30),
                                              child: TextButton(
                                                onPressed: (){
                                                  if(loggedIn){
                                                    Navigator.pushNamed(context, '/payment-methods');
                                                  }
                                                  else{
                                                    Navigator.pushNamed(context, '/login');
                                                  }
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.credit_card ,color: Colors.blue,),
                                                  title: Text(cardSelected!.nickname),
                                                  trailing: Icon(Icons.arrow_right,color:Colors.black,),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    }
                                    return const Text("Please wait");
                                  },

                                ),


                                SizedBox(height: 10,),

                                Row(
                                  children: [

                                    Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      height: 50,
                                      margin: EdgeInsets.all(10),
                                      child: ListTile(
                                        title:   Text('$globalServicePrice EGP', style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),),
                                        subtitle: Text(serviceDuration),
                                      ),
                                    ),


                                    FutureBuilder(
                                      future: Future.wait([categoryData(),userData()]),
                                      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                        if(snapshot.connectionState == ConnectionState.done){
                                          if(snapshot.hasError){
                                            return const Text("There is an error");
                                          }
                                          else if(snapshot.hasData){
                                            return Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context).size.width / 2,
                                              height: 54,
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: nothingSelected == false || cashSelected == true?Colors.deepPurple:Colors.grey,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: MaterialButton(
                                                onPressed: () async {

                                                  if(nothingSelected == false || cashSelected == true){
                                                    startYear = timePicked.year;
                                                    startMonth = timePicked.month;
                                                    startDay = timePicked.day;

                                                    globalYear = startYear;
                                                    globalDay = startDay;
                                                    globalDayWords = currentDayOfWeek;

                                                    String startHourString = getHour(currentDayTimings['$currentTime']);
                                                    String startMinuteString = getMinute(currentDayTimings['$currentTime']);

                                                    startHour = int.parse(startHourString);
                                                    startMinutes = int.parse(startMinuteString);

                                                    String startTimeEnd = getAMorPM(
                                                        currentDayTimings['$currentTime']);

                                                    if (startTimeEnd == 'PM') {
                                                      if (startHour == 12) {
                                                        startHourActual = startHour;
                                                      }
                                                      else {
                                                        startHourActual = startHour + 12;
                                                      }
                                                    }
                                                    else {
                                                      startHourActual = startHour;
                                                    }

                                                    int minutes = getServiceDurationInMinutes(
                                                        serviceDuration);

                                                    String endHourString = generateNewHour(
                                                        startMinuteString, startHourString, minutes);

                                                    endHour = int.parse(endHourString);

                                                    String endTime = generateEndTime(currentDayTimings['$currentTime'], serviceDuration);

                                                    globalEndTime = endTime;

                                                    String endMinutesString = getMinute(endTime);
                                                    endMinutes = int.parse(endMinutesString);

                                                    String endTimeEnd = getAMorPM(endTime);

                                                    if (endTimeEnd == 'PM') {
                                                      if (endHour == 12) {
                                                        endHourActual = endHour;
                                                      }
                                                      else {
                                                        endHourActual = endHour + 12;
                                                      }
                                                    }
                                                    else {
                                                      endHourActual = endHour;
                                                    }

                                                    globalStartTime = currentDayTimings['$currentTime'];


                                                    bookingClicked = true;

                                                    if(loggedIn){
                                                      if(typeOfItemSelected == 'Services'){
                                                        print("1");
                                                        await databaseService.updateAppointmentStats(
                                                          currentCategory,
                                                          currentShopIndex,
                                                          months[startMonth-1],
                                                          snapshot.data![0]['$currentShopIndex']['appointments']['appointment-amount']+1,
                                                        );


                                                        print("2");

                                                        await databaseService.addAppointment(
                                                          userLoggedInIndex,
                                                          globalRequiresConfirmation,
                                                          globalDayWords,
                                                          snapshot.data![1]['$userLoggedInIndex']['full-name'],
                                                          snapshot.data![1]['$userLoggedInIndex']['email'],
                                                          snapshot.data![1]['$userLoggedInIndex']['phone-number'],
                                                          currentCategory,
                                                          currentShopIndex,
                                                          snapshot.data![0]['$currentShopIndex']['appointments']['appointment-amount']+1,
                                                          snapshot.data![0]['$currentShopIndex']['appointments']['incomplete']+1,
                                                          startYear,
                                                          startMonth,
                                                          startDay,
                                                          startHour,
                                                          startHourActual,
                                                          startMinutes,
                                                          startYear,
                                                          startMonth,
                                                          startDay,
                                                          endHour,
                                                          endHourActual,
                                                          endMinutes,
                                                          'blank',
                                                          serviceBooked,
                                                          globalServicePrice,
                                                          globalServiceLinked?"none":snapshot.data![0]['$currentShopIndex']['staff-members']['$currentEmployeeIndex']['member-name'],
                                                          globalServiceLinked?"none":snapshot.data![0]['$currentShopIndex']['staff-members']['$currentEmployeeIndex']['member-role'],
                                                          'Services',
                                                          serviceDuration,
                                                          snapshot.data![1]["$userLoggedInIndex"]['appointment-amount']+1,
                                                          globalStartTime,
                                                          globalEndTime,
                                                        );

                                                        print("3");


                                                        globalTime = '$globalStartTime-$globalEndTime';

                                                        await databaseService.updateUserAppointments(
                                                          globalRequiresConfirmation,
                                                          snapshot.data![1]["$userLoggedInIndex"]['appointment-amount']+1,
                                                          userLoggedInIndex,
                                                          "${onCalender?globalDay:DateTime.now().day} ${onCalender?DateFormat.LLLL().format(timePicked):DateFormat.LLLL().format(DateTime.now())} ${onCalender?globalYear:DateTime.now().year}",
                                                          serviceBooked,
                                                          currentShop,
                                                          serviceDuration,
                                                          globalServiceLinked?"none":snapshot.data![0]['$currentShopIndex']['staff-members']['$currentEmployeeIndex']['member-name'],
                                                          globalServicePrice,
                                                          globalStartTime,
                                                          globalEndTime,
                                                          startDay,
                                                          startMonth,
                                                          startYear,
                                                          snapshot.data![0]['$currentShopIndex']['images']['${-1}'],
                                                        );

                                                        print("4");
                                                      }
                                                      else{

                                                        // TEST THIS PART
                                                        await databaseService.addMember(
                                                          currentCategory,
                                                          currentShopIndex,
                                                          snapshot.data![0]['$currentShopIndex']['members-amount']+1,
                                                          snapshot.data![0]['$currentShopIndex']['memberships']['$currentMembershipIndex']['name'],
                                                          snapshot.data![1]['$userLoggedInIndex']['full-name'],
                                                          snapshot.data![1]['$userLoggedInIndex']['email'],
                                                          DateTime.now().day,
                                                          DateTime.now().month,
                                                          DateTime.now().year,
                                                        );

                                                        await databaseService.addUserMembership(
                                                          userLoggedInIndex,
                                                          snapshot.data![1]['$userLoggedInIndex']['membership-amount']+1,
                                                          snapshot.data![0]['$currentShopIndex']['memberships']['$currentMembershipIndex']['name'],
                                                          currentShop,
                                                          DateTime.now().day,
                                                          DateTime.now().month,
                                                          DateTime.now().year,
                                                        );
                                                      }

                                                      int clientIndex = 0;
                                                      bool clientFound = false;
                                                      while(clientIndex <= snapshot.data![0]['$currentShopIndex']['client-amount']){

                                                        if(snapshot.data![0]['$currentShopIndex']['clients']['$clientIndex']['email'] == snapshot.data![1]['$userLoggedInIndex']['email']){
                                                          clientFound = true;
                                                          break;
                                                        }

                                                        clientIndex++;
                                                      }

                                                      print("5");

                                                      if(!clientFound){
                                                        await databaseService.addClient(
                                                          currentCategory,
                                                          currentShopIndex,
                                                          snapshot.data![0]['$currentShopIndex']['client-amount']+1,
                                                          snapshot.data![1]['$userLoggedInIndex']['full-name'],
                                                          snapshot.data![1]['$userLoggedInIndex']['email'],
                                                          snapshot.data![1]['$userLoggedInIndex']['phone-number'],
                                                        );
                                                      }
                                                      Navigator.pushNamed(context, '/booked');
                                                    }
                                                    else{
                                                      Navigator.pushNamed(context, '/login');
                                                    }
                                                  }


                                                },
                                                child: Text(
                                                  'Book',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return const CircularProgressIndicator();
                                      },

                                    ),


                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  );
                }
                else{

                  // MEMBERSHIPS LOGIC

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*2,
                    child: SingleChildScrollView(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.height / 7,
                            child: Image.network(
                              snapshot.data['$currentShopIndex']['images']['${-1}'],
                              alignment: Alignment.center,

                            ),
                          ),

                          SizedBox(height: 35,),

                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Text('You are one step closer to becoming a member!', style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          //SizedBox(height: 35,),


                          Text('Membership Name', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(height: 5,),

                          Text(snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['name'], style: TextStyle(
                            fontSize: 18,
                          ),),

                          SizedBox(height: 20,),

                          Text('Membership Services', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(height: 5,),

                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            //height: 100,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['selected-services-amount'] ,
                                itemBuilder: (context,index){
                                  return Center(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text(snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['selected-services'][index],style: TextStyle(
                                        fontSize: 18,
                                      ),),
                                    ),
                                  );
                                }
                                ),
                          ),

                          SizedBox(height: 10,),
                          (snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['discounted-amount'] > 0)?Text('Discounted Services', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),):Container(),
                          (snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['discounted-amount'] > 0)?
                          SizedBox(height: 5,):Container(),
                          (snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['discounted-amount'] > 0)?
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                           // height: 100,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['discounted-amount'] ,
                                itemBuilder: (context,index){
                                  return Center(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(0),
                                            child: Text('${snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['selected-discounted-services'][index]} ',style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),),
                                          ),
                                          Text(' ${snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['selected-discounted-services-percentages'][index]}%', style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                          ),),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ):Container(),

                          SizedBox(height: 10,),
                          Text('Membership Duration', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(height: 5,),
                          Text('${snapshot.data['$currentShopIndex']['memberships']['$currentMembershipIndex']['duration']} month/s', style: TextStyle(
                            fontSize: 18,
                          ),),

                          SizedBox(height: 40,),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Card(
                              elevation: 10.0,
                              child: Column(
                                children: [

                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text('Payment Method', style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),

                                      TextButton(
                                        onPressed: (){

                                          if(loggedIn){
                                            Navigator.pushNamed(context, '/add-card');
                                          }
                                          else{
                                            Navigator.pushNamed(context, '/login');
                                          }

                                        },
                                        child: Row(
                                          children: [

                                            Icon(Icons.add,size: 20,color: Colors.black,),

                                            Text('Add Credit Card', style: TextStyle(
                                              color: Colors.black,
                                            ),),


                                          ],
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  ),

                                  SizedBox(height: 10,),

                                  Container(
                                    margin: EdgeInsets.only(right: 30),
                                    child: TextButton(
                                      onPressed: (){
                                        if(loggedIn){
                                          Navigator.pushNamed(context, '/payment-methods');
                                        }
                                        else{
                                          Navigator.pushNamed(context, '/login');
                                        }
                                      },
                                      child: ListTile(
                                        leading: Icon(Icons.credit_card ,color: Colors.blue,),
                                        title: savedCreditCards.length > 0?Text(savedCreditCards[0].nickname):Text('No Credit Card Added'),
                                        trailing: Icon(Icons.arrow_right,color:Colors.black,),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width / 3,
                                        height: 50,
                                        margin: EdgeInsets.all(10),
                                        child: ListTile(
                                          title:   Text('$globalServicePrice EGP', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                      ),

                                      Expanded(
                                        child: FutureBuilder(
                                          future: Future.wait([categoryData(),userData()]),
                                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                            if(snapshot.connectionState == ConnectionState.done){
                                              if(snapshot.hasError){
                                                return const Text("There is an error");
                                              }
                                              else if(snapshot.hasData){
                                                return Container(
                                                  margin: EdgeInsets.only(right: 10),
                                                  alignment: Alignment.center,
                                                  width: 200,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: cardSelected != null?Colors.deepPurple:Colors.grey,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () async {


                                                      if(cardSelected != null){

                                                        await databaseService.addMember(
                                                          currentCategory,
                                                          currentShopIndex,
                                                          snapshot.data[0]['$currentShopIndex']['members-amount']+1,
                                                          snapshot.data[0]['$currentShopIndex']['memberships']['$currentMembershipIndex']['name'],
                                                          snapshot.data[1]['$userLoggedInIndex']['full-name'],
                                                          snapshot.data[1]['$userLoggedInIndex']['email'],
                                                          DateTime.now().day,
                                                          DateTime.now().month,
                                                          DateTime.now().year,
                                                        );

                                                        await databaseService.addUserMembership(
                                                          userLoggedInIndex,
                                                          snapshot.data[1]['$userLoggedInIndex']['membership-amount']+1,
                                                          snapshot.data[0]['$currentShopIndex']['memberships']['$currentMembershipIndex']['name'],
                                                          currentShop,
                                                          DateTime.now().day,
                                                          DateTime.now().month,
                                                          DateTime.now().year,
                                                        );

                                                        int clientIndex = 0;
                                                        bool clientFound = false;
                                                        while(clientIndex <= snapshot.data[0]['$currentShopIndex']['client-amount']){

                                                          if(snapshot.data[0]['$currentShopIndex']['clients']['$clientIndex']['email'] == snapshot.data[1]['$userLoggedInIndex']['email']){
                                                            clientFound = true;
                                                            break;
                                                          }

                                                          clientIndex++;
                                                        }

                                                        print("5");

                                                        if(!clientFound){
                                                          await databaseService.addClient(
                                                            currentCategory,
                                                            currentShopIndex,
                                                            snapshot.data[0]['$currentShopIndex']['client-amount']+1,
                                                            snapshot.data[1]['$userLoggedInIndex']['full-name'],
                                                            snapshot.data[1]['$userLoggedInIndex']['email'],
                                                            snapshot.data[1]['$userLoggedInIndex']['phone-number'],
                                                          );
                                                        }
                                                        Navigator.pushNamed(context, '/booked');

                                                      }



                                                    },
                                                    child: Text("Purchase", style: TextStyle(
                                                      color: Colors.white,
                                                    ),),
                                                  ),
                                                );
                                              }
                                            }
                                            return const CircularProgressIndicator();
                                          },

                                        ),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                          ),



                          SizedBox(height: 50,),


                        ],
                      ),
                    ),
                  );


                }


              }
            }
            return const Text("Please wait");
          },

        ),
      ),
    );
  }


  Widget timingsData(String time, int index, AsyncSnapshot<dynamic> snapshot) {
    return Container(
      width: 130,
      height: 100,
      margin: EdgeInsets.only(left: 20, top: 10),
      decoration: BoxDecoration(
        color: Colors.white ,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: index == currentTime ?Colors.deepPurple:Colors.grey,
          width: index == currentTime ?3:1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            margin: EdgeInsets.only(right: 2, left: 5),
            child: Icon(
              Icons.access_time,
              color: index == currentTime ?Colors.black:Colors.grey,
              size: 18,
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 2, right: 5),
            child: Text(time,
              style: TextStyle(
                color: index == currentTime ?Colors.black:Colors.grey[800],
                fontSize: 17,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget buildStaffMembers(AsyncSnapshot<dynamic> snapshot) {
    if (globalServiceLinked) {
      return Container();
    }
    else {
      return Container(
        height: 100,
        child: ListView.builder(
          itemCount: snapshot.data['$currentShopIndex']['staff-members-amount'] + 1,
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            if (index != 0) {
              if (snapshot.data['$currentShopIndex']['staff-members']['${index - 1}']['member-role'] != 'Owner'
                  &&
                  snapshot.data['$currentShopIndex']['staff-members']['${index - 1}']['member-role'] != 'Manager'
                  && findService(serviceBooked, index - 1, snapshot)
              ) {
                return Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentEmployeeIndex = index - 1;
                        });
                        //print("CURRENT EMPLOYEE: $currentEmployeeIndex");
                      },
                      child: CircleAvatar(
                        radius: 32.0,
                        backgroundColor: (currentEmployeeIndex == index - 1)
                            ? Colors.greenAccent
                            : Colors.transparent,
                        child: CircleAvatar(
                          radius: 28.0,
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            child: Image.asset(
                                'assets/all_images/no_profile_11.jpg'),
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10,)),
                    Text(snapshot.data['$currentShopIndex']['staff-members']['${index - 1}']['member-name'],
                      style: TextStyle(
                        fontWeight: (currentEmployeeIndex == index - 1)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }
              else {
                return Container();
              }
            }
            else if (index == 0) {
              return Column(
                children: [
                  MaterialButton(
                    onPressed: () {

                      int mostAmountOfDuration = 0;


                      int staffIndex = 1;

                      while(staffIndex < snapshot.data['$currentShopIndex']['staff-members-amount']){

                        int currentStaffDuration = 0;

                        if(findService(serviceBooked, staffIndex, snapshot)){

                          int appointmentIndex = 0;
                          while(appointmentIndex <= snapshot.data['$currentShopIndex']['appointments']['appointment-amount']){
                            if(snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['appointment-status'] == 'incomplete'){
                              if(snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['member-name'] == snapshot.data['$currentShopIndex']['staff-members']['$staffIndex']['member-name']){
                                int serviceDuration = getServiceDurationInMinutes(snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['service-duration']);
                                currentStaffDuration += serviceDuration;
                              }
                            }

                            appointmentIndex++;
                          }

                          if(currentStaffDuration >= mostAmountOfDuration){
                            mostAmountOfDuration = currentStaffDuration;
                            mostAvailableEmployee = staffIndex;
                          }
                        }

                        staffIndex++;
                      }



                      setState(() {
                        currentEmployeeIndex = index;
                      });
                      print("CURRENT EMPLOYEE: $mostAvailableEmployee");
                    },
                    child: CircleAvatar(
                      radius: 32.0,
                      backgroundColor: (currentEmployeeIndex == index) ? Colors
                          .greenAccent : Colors.transparent,
                      child: CircleAvatar(
                        radius: 28.0,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          child: Image.asset(
                              'assets/all_images/no_profile_11.jpg'),
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10,)),
                  Text('Anybody',
                    style: TextStyle(
                      fontWeight: (currentEmployeeIndex == index) ? FontWeight
                          .bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }
            else {
              return Container();
            }
          },
        ),
      );
    }
  }


  // GETS MINUTE FROM INPUT STRING
  String getMinute(String time) {
    // WHERE THE MINUTE WILL BE STORES
    String minute = "";

    // CHARACTER INDEX IN TIME STRING (EXAMPLE "10:00 PM" IS TIME STRING)
    int charIndex = 0;

    // CHECKS IF "charIndex" IS AT THE FIRST NUMBER OF THE MINUTE
    bool reachedMinute = false;

    while (charIndex < time.length) {
      // IF "reachedMinute" THEN ADD THE CURRENT CHARACTER TO THE MINUTE STRING
      if (reachedMinute) {
        minute += time[charIndex];
      }

      // IF CURRENT CHARACTER IS ':', THIS MEANS NEXT CHARACTER IS THE FIRST NUMBER OF THE MINUTE
      if (time[charIndex] == ':') {
        reachedMinute = true;
      }

      // IF CURRENT CHARACTER IS " " (A SPACE), THEN THE LAST
      // NUMBER OF THE MINUTE IS DONE SO RETURN THE MINUTE
      else if (time[charIndex] == " ") {
        return minute;
      }

      charIndex++;
    }

    return minute;
  }


  // GETS HOUR FROM TIME STRING
  String getHour(String time) {
    // WHERE THE HOUR WILL BE STORED
    String hour = "";

    // CHARACTER INDEX IN TIME STRING (EXAMPLE "10:00 PM" IS TIME STRING)
    int charIndex = 0;

    while (charIndex < time.length) {
      if (time[charIndex] == ':') {
        return hour;
      }
      else {
        hour += time[charIndex];
      }

      charIndex++;
    }

    return hour;
  }


  // GETS MINUTE FROM INPUT STRING
  String generateNewMinute(int minuteGap, String currentMinute) {
    // WHERE THE MINUTE WILL BE STORES
    String newMinute = "";

    int currentMinuteInt = int.parse(currentMinute);
    int newMinuteInt = currentMinuteInt + minuteGap;

    if (newMinuteInt >= 60) {
      if ((newMinuteInt % 2) == 0) {
        newMinute = '00';
      }
      else {
        newMinute = '${newMinuteInt - 60}';
      }
    }
    else if (newMinuteInt < 10) {
      newMinute = '0$newMinuteInt';
    }
    else {
      newMinute = '$newMinuteInt';
    }

    return newMinute;
  }

  // GETS MINUTE FROM INPUT STRING
  String generateNewHour(String oldMinute, String currentHour, int minuteGap) {
    // WHERE THE NEW HOUR WILL BE STORED
    String newHour = "";

    int oldMinuteInt = int.parse(oldMinute);

    int newMinute = oldMinuteInt + minuteGap;

    int minuteDifference = newMinute - oldMinuteInt;

    int hoursPassed = 0;

    if (newMinute >= 60) {
      hoursPassed = (minuteDifference / 60).ceil();
    }

    int currentHourInt = int.parse(currentHour);
    int newHourInt = currentHourInt + hoursPassed;

    if (newHourInt > 12) {
      newHourInt = newHourInt - 12;
    }


    newHour = '$newHourInt';

    return newHour;
  }

  String getAMorPM(String time) {
    // WHERE THE MINUTE WILL BE STORES
    String output = "";

    // CHARACTER INDEX IN TIME STRING (EXAMPLE "10:00 PM" IS TIME STRING)
    int charIndex = 0;

    // CHECKS IF "charIndex" IS AT THE FIRST NUMBER OF THE MINUTE
    bool reachedLetter = false;

    while (charIndex < time.length) {
      if (time[charIndex] == 'A' || time[charIndex] == 'P') {
        reachedLetter = true;
      }

      if (reachedLetter) {
        output += time[charIndex];
      }

      charIndex++;
    }

    return output;
  }

  String createAMorPM(String oldHour, String newHour, String currentEnd) {
    // WHERE THE 'AM' OR 'PM' WILL BE STORES
    String output = "";

    int oldHourInt = int.parse(oldHour);
    int newHourInt = int.parse(newHour);

    if (oldHourInt < 12 && newHourInt <= 12) {
      if (newHourInt == 12) {
        if (currentEnd == 'AM') {
          output = 'PM';
        }
        else {
          output = 'AM';
        }
      }
      else if (oldHourInt > newHourInt) {
        if (currentEnd == 'AM') {
          output = 'PM';
        }
        else {
          output = 'AM';
        }
      }
      else {
        output = currentEnd;
      }
    }
    else {
      output = currentEnd;
    }

    return output;
  }


  dynamic createTimeData(String startTime, String endTime, int minuteGap) {
    dynamic timeDataMap = {};

    String currentTime = startTime;

    int timeDataMapIndex = 0;


    while (currentTime != endTime) {
      // CURRENT INDEX IN TIME DATA MAP IS EQUAL TO THE CURRENT TIME


      timeDataMap['$timeDataMapIndex'] = currentTime;

      String currentHour = getHour(currentTime);

      String currentMinute = getMinute(currentTime);

      // THIS STRING WILL GET EITHER 'AM' OR 'PM' FROM THE CURRENT TIME
      String currentEnd = getAMorPM(currentTime);

      currentTime = generateNewTime(
          currentTime, currentHour, currentMinute, currentEnd, minuteGap);

      timeDataMapIndex++;
    }

    timeDataMap['$timeDataMapIndex'] = currentTime;

    return timeDataMap;
  }


  String generateNewTime(String currentTime, String currentHour,
      String currentMinute, String currentEnd, int minuteGap) {
    // THIS STRING WILL STORE THE NEW HOUR
    String newHour = generateNewHour(currentMinute, currentHour, minuteGap);

    // THIS STRING WILL STORE THE NEW MINUTE USING THE MINUTE GAP
    String newMinute = generateNewMinute(minuteGap, currentMinute);

    // THIS STRING WILL STORE THE NEW 'AM' OR 'PM' DEPENDING ON THE NEW HOUR
    String newEnd = createAMorPM(currentHour, newHour, currentEnd);

    // UPDATE CURRENT TIME TO BE THE NEW TIME
    currentTime = '$newHour:$newMinute $newEnd';

    return currentTime;
  }

  int getServiceDurationInMinutes(String serviceDuration) {
    int serviceDurationInMinutes = 0;

    String hour = '';
    String minute = '';

    int durationIndex = 0;
    while (durationIndex < serviceDuration.length) {
      if (serviceDuration[durationIndex] == 'h') {
        durationIndex++;

        while (serviceDuration[durationIndex] != 'm') {
          minute += serviceDuration[durationIndex];
          durationIndex++;
        }
        break;
      }
      else {
        hour += serviceDuration[durationIndex];
      }

      durationIndex++;
    }

    int hourInt = int.parse(hour);
    int minuteInt = int.parse(minute);

    serviceDurationInMinutes = (hourInt * 60) + minuteInt;

    return serviceDurationInMinutes;
  }


  bool isInConflict(int appointmentIndex, String serviceName, String staffName,
      int day, int month, int year, String currentTime,
      AsyncSnapshot<dynamic> snapshot) {
    // IF SERVICE NAME IN THE CURRENT APPOINTMENT IS EQUAL TO CURRENT SERVICE TO BE BOOKED
    // AND STAFF MEMBER NAME IN THE CURRENT APPOINTMENT IS EQUAL TO THE CURRENT STAFF MEMBER SELECTED
    // AND THE DAY, MONTH, AND YEAR IN THE CURRENT APPOINTMENT ARE EQUAL TO WHAT IS SELECTED IN THE CALENDAR
    // THEN WE CAN BEGIN TO CHECK IF THE TIME SELECTED IS OCCUPIED OR NOT

    if (snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['appointment-status'] ==
        'incomplete') {
      //print('X');
      if (snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['member-name'] ==
          staffName) {
        //print('B');
        if (snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['start-day'] ==
            day) {
          //  print('C');
          if (snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['start-month'] ==
              month) {
            //      print('D');
            if (snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['start-year'] ==
                year) {
              // print('EQUAL');
              // START TIME STORED FROM DATABASE IN VARIABLE
              String startTime = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['start-time'];

              // END TIME
              String endTime = snapshot.data['$currentShopIndex']['appointments']['$appointmentIndex']['end-time'];

              // FUNCTION THAT CHECKS IF CURRENT TIME IS ALREADY OCCUPIED
              bool checkOccupied = isOccupied(
                  startTime, endTime, currentTime, currentMinuteGap);

              // FUNCTION THAT GETS THE DURATION OF A SERVICE IN MINUTES
              int currentServiceDuration = getServiceDurationInMinutes(
                  serviceDuration);

              // FUNCTION THAT CHECKS IF THE CURRENT TIME WILL CLASH WITH ANOTHER APPOINTMENT
              // GIVEN THE DURATION OF THE SERVICE
              bool checkClashing = isClashing(
                  startTime, currentTime, currentServiceDuration);


              //print('CURRENT TIME: $currentTime');
              //
              if (checkOccupied || checkClashing) {

                if(checkOccupied){
                  print('$currentTime occupied for $startTime-$endTime');
                  print(' ');
                }
                if(checkClashing){
                  print('$currentTime clashing for $startTime-$endTime');
                  print(' ');
                }




                if (bookingsPerSlot['$startTime-$endTime-$staffName'] >= snapshot.data['$currentShopIndex']['services']['$currentServiceIndex']['max-amount-per-timing']) {
                  return true;
                }
                else {
                  return false;
                }
              }
            }
          }
        }
      }
    }


    return false;
  }


  bool isClashing(String startTime, String currentTime,
      int currentServiceDuration) {
    String startHour = getHour(startTime);
    String currentHour = getHour(currentTime);


    int startHourInt = int.parse(startHour);
    int currentHourInt = int.parse(currentHour);

    int hourDifference = 0;


    int hourIndex = 0;

    while (hours[hourIndex] != currentHourInt) {
      hourIndex++;
    }

    while (hours[hourIndex] != startHourInt) {
      hourDifference++;
      hourIndex++;

      if (hourIndex == hours.length) {
        hourIndex = 0;
      }
    }

    String startMinute = getMinute(startTime);
    String currentMinute = getMinute(currentTime);

    int startMinuteInt = int.parse(startMinute);
    int currentMinuteInt = int.parse(currentMinute);

    int minuteDifference = 0;

    if (startMinuteInt > currentMinuteInt) {
      minuteDifference = startMinuteInt - currentMinuteInt;
    }
    else {
      minuteDifference = currentMinuteInt - startMinuteInt;
    }

    int hourToMinutes = hourDifference * 60;

    int totalMinutes = 0;

    if (startMinuteInt > currentMinuteInt) {
      totalMinutes = hourToMinutes + minuteDifference;
    }
    else {
      totalMinutes = hourToMinutes - minuteDifference;
    }

    if (currentServiceDuration > totalMinutes) {
      return true;
    }

    return false;
  }

  bool isOccupied(String startTime, String endTime, String currentTime, int currentMinuteGap) {

    print('current time: $currentTime');
    print('start time: $startTime');
    print('end time: $endTime');
    print('');


    bool currentGreaterThanEndTime = isGreater(currentTime,endTime);

    bool currentGreaterThanStartTime = isGreater(currentTime, startTime);

    if(currentGreaterThanStartTime){
      print('$currentTime is greater than $startTime');
    }

    if(!currentGreaterThanEndTime){
      print('$currentTime is smaller than $endTime');
    }


    if(currentGreaterThanEndTime == false && currentGreaterThanStartTime){
      return true;
    }
    return false;
  }




  bool isGreater(String firstTime, String secondTime){

    String firstTimeEnd = getAMorPM(firstTime);
    String secondTimeEnd  = getAMorPM(secondTime);

    String firstTimeHour = getHour(firstTime);
    String secondTimeHour = getHour(secondTime);

    int firstTimeHourInt = int.parse(firstTimeHour);
    int secondTimeHourInt = int.parse(secondTimeHour);

    String firstTimeMinute = getMinute(firstTime);
    String endTimeMinute = getMinute(secondTime);

    int firstTimeMinuteInt = int.parse(firstTimeMinute);
    int secondTimeMinuteInt = int.parse(endTimeMinute);

    if(firstTimeEnd == 'AM' && firstTimeHourInt == 12){
      firstTimeHourInt = 0;
    }
    if(secondTimeEnd == 'AM' && secondTimeHourInt == 12){
      secondTimeHourInt = 0;
    }

    if(firstTimeEnd == 'PM'){
      if(firstTimeHourInt != 12){
        firstTimeHourInt += 12;
      }
    }
    if(secondTimeEnd == 'PM'){
      if(secondTimeHourInt != 12){
        secondTimeHourInt += 12;
      }
    }

    if(firstTimeHourInt == secondTimeHourInt){
     if(firstTimeMinuteInt >= secondTimeMinuteInt){
       print('1');
       return true;
     }
    }
    else if(firstTimeHourInt > secondTimeHourInt){
      print('2');
      return true;
    }
    return false;
  }


  int getServiceDurationHour(String serviceDuration) {
    String hour = '';

    int durationIndex = 0;
    while (durationIndex < serviceDuration.length) {
      if (serviceDuration[durationIndex] == 'h') {
        break;
      }
      else {
        hour += serviceDuration[durationIndex];
      }
      durationIndex++;
    }

    int hourInt = int.parse(hour);
    return hourInt;
  }

  int getServiceDurationMinute(String serviceDuration) {
    String minute = '';

    int durationIndex = 0;
    while (durationIndex < serviceDuration.length) {
      if (serviceDuration[durationIndex] == 'h') {
        durationIndex++;
        while (serviceDuration[durationIndex] != 'm') {
          minute += serviceDuration[durationIndex];
          durationIndex++;
        }
        break;
      }
      durationIndex++;
    }

    int minuteInt = int.parse(minute);
    return minuteInt;
  }

  String generateEndTime(String startTime, String serviceDuration) {
    // OUTPUT
    String endTime = "";

    String endHour = "";
    String endMinute = "";

    // Hour duration and minute duration
    int hourDuration = getServiceDurationHour(serviceDuration);
    int minuteDuration = getServiceDurationMinute(serviceDuration);

    String startHour = getHour(startTime);
    String startMinute = getMinute(startTime);

    int startHourInt = int.parse(startHour);

    // THIS STRING WILL STORE THE END HOUR
    int endHourInt = generateEndHour(startHour, hourDuration);

    // THIS STRING WILL STORE THE NEW MINUTE USING THE MINUTE GAP
    int endMinuteInt = generateEndMinute(startMinute, minuteDuration);

    if (endMinuteInt > 60 || endMinuteInt == 60) {
      endHourInt++;

      if (endHourInt > 12) {
        endHourInt -= 12;
      }
    }

    bool pastTwelve = reachedPastTwelve(startHourInt, endHourInt);
    String startTimeEnd = getAMorPM(startTime);

    print('end minute: $endMinuteInt');

    if (endMinuteInt == 60 || endMinuteInt == 0) {
      if (pastTwelve) {
        if (startTimeEnd == 'AM') {
          endTime = '$endHourInt:00 PM';
        }
        else {
          endTime = '$endHourInt:00 AM';
        }
      }
      else {
        endTime = '$endHourInt:00 $startTimeEnd';
      }
    }
    else if (endMinuteInt > 60) {
      String updatedEndMinute = '${endMinuteInt - 60}';

      if (pastTwelve) {
        if (startTimeEnd == 'AM') {
          endTime = '$endHourInt:$updatedEndMinute PM';
        }
        else {
          endTime = '$endHourInt:$updatedEndMinute AM';
        }
      }
      else {
        endTime = '$endHourInt:$updatedEndMinute $startTimeEnd';
      }
    }
    else {
      endMinute = '$endMinuteInt';

      if (pastTwelve) {
        if (startTimeEnd == 'AM') {
          endTime = '$endHourInt:$endMinute PM';
        }
        else {
          endTime = '$endHourInt:$endMinute AM';
        }
      }
      else {
        endTime = '$endHourInt:$endMinute $startTimeEnd';
      }
    }

    return endTime;
  }


  bool reachedPastTwelve(int startHour, int endHour) {
    bool pastTwelve = true;
    int hourIndex = 0;

    List<int> hoursToLoop = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

    while (hourIndex < hoursToLoop.length) {
      if (hoursToLoop[hourIndex] == startHour) {
        hourIndex++;
        while (hourIndex < hoursToLoop.length) {
          if (hoursToLoop[hourIndex] == endHour) {
            pastTwelve = false;
            break;
          }
          hourIndex++;
        }
        break;
      }

      hourIndex++;
    }

    return pastTwelve;
  }


  int generateEndHour(String startHour, int hourDuration) {
    int startHourInt = int.parse(startHour);
    int endHour = startHourInt + hourDuration;

    if (endHour > 12) {
      endHour -= 12;
    }

    return endHour;
  }

  int generateEndMinute(String startMinute, int minuteDuration) {
    int startMinuteInt = int.parse(startMinute);
    print('start minute: $startMinuteInt');
    print('minute duration: $minuteDuration');
    int endMinute = startMinuteInt + minuteDuration;


    return endMinute;
  }

  // Checks if staff member at "staffIndex" has the current cart's service title in their services
  bool findService(String service, int staffIndex,
      AsyncSnapshot<dynamic> snapshot) {
    int serviceIndex = 0;
    while (serviceIndex < snapshot.data['$currentShopIndex']['staff-members']['$staffIndex']['member-services-amount']) {
      if (service == snapshot.data['$currentShopIndex']['staff-members']['$staffIndex']['member-services']['$serviceIndex']) {
        return true;
      }

      serviceIndex++;
    }

    return false;
  }

  bool passedTime(int hour, int minute, int day, int month, int year) {
    if(DateTime.now().day == day && DateTime.now().month == month && DateTime.now().year == year) {
      if(hour < DateTime.now().hour) {
        return true;
      }
      else if(hour == DateTime.now().hour) {
        if (minute < DateTime.now().minute) {
          return true;
        }
      }
    }
    return false;
  }
}
