import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants.dart';

class DatabaseService{

  final CollectionReference shops = FirebaseFirestore.instance.collection('shops');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');


  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  signInWithGoogle() async
  {
    try{
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
      }
    }
    on FirebaseAuthException catch(e){
      print(e.message);
      rethrow;
    }
  }

  Future addAppointment(
      String dayOfWeek,
      String name,
      String email,
      String category,
      int currentShopIdx,
      int appointmentAmount,
      int incompleteAmount,
      int startYear,
      int startMonth,
      int startDay,
      int startHour,
      int startHourActual,
      int startMinutes,
      int endYear,
      int endMonth,
      int endDay,
      int endHour,
      int endHourActual,
      int endMinutes,
      String clientName,
      String serviceName,
      String servicePrice,
      String memberName,
      String memberRole,
      String type,
      String serviceDuration,
      int userAppointmentIndex,
      String startTime,
      String endTime,
      ) async {
    return await shops.doc(category).set({
      '$currentShopIdx' : {
        'appointments':{
          '$appointmentAmount':{
            'user-appointment-index': userAppointmentIndex,
            'appointment-status': 'incomplete',
            'appointment-type': type,
            'day-words': dayOfWeek,
            'start-year': startYear,
            'start-month': startMonth,
            'start-day': startDay,
            'start-hour': startHour,
            'start-hour-actual': startHourActual,
            'start-minutes': startMinutes,

            'start-time': startTime,
            'end-time': endTime,

            'end-year': endYear,
            'end-month': endMonth,
            'end-day': endDay,
            'end-hour': endHour,
            'end-hour-actual': endHourActual,
            'end-minutes': endMinutes,

            'client-name': name,
            'client-email': email,
            'service-name': serviceName,
            'service-price': servicePrice,
            'service-duration': serviceDuration,
            'member-name': memberName,
            'member-role': memberRole,

          },
          'appointment-amount': appointmentAmount,
          'incomplete': incompleteAmount,
        },
      },
    },SetOptions(merge: true),
    );
  }

  Future updateAppointmentStats(String category,int currentShopIdx, String currentMonth,int appointmentAmount) async {
    return await shops.doc(category).set({
      '$currentShopIdx' : {
        'appointment-stats': {
          currentMonth:{
            'appointment-amount': appointmentAmount,
          },
        },
      },
    },SetOptions(merge: true),
    );
  }

  Future addClient(String category, int currentShopIdx, int clientAmount, String clientName, String clientEmail, String clientNumber) async {
    return await shops.doc(category).set({
      '$currentShopIdx' : {
        'client-amount':clientAmount,
        'clients':{
          '$clientAmount': {
            'type': 'new',
            'name': clientName,
            'email': clientEmail,
            'phone': clientNumber,
            'month': months[DateTime.now().month -1],
            'appointments':0,
            'amount-paid': 0,
          },
        },
      },
    },SetOptions(merge: true),
    );
  }

  Future updateClient(String category, int currentShopIdx, int clientIndex, int appAmount) async {
    return await shops.doc(category).set({
      '$currentShopIdx' : {
        'clients':{
          '$clientIndex': {
            'appointments':appAmount,
          },
        },
      },
    },SetOptions(merge: true),
    );
  }

  Future changeAvailability(String category, int currentShopIdx, int currentMemberIndex, int currentAvailabilityIndex, String currentDay) async {
    return await shops.doc(category).set({
      '$currentShopIdx' : {
        'staff-members': {
          '$currentMemberIndex': {
            'member-availability-conditions': {
              currentDay: {
                '$currentAvailabilityIndex': false,
              },
            },
          },
        },
      },
    },SetOptions(merge: true),
    );
  }

  Future addReview(String category, int currentShopIdx, int reviewIndex, String review, int reviewRating, String user, double overallRating) async {
    return await shops.doc(category).set({
      '$currentShopIdx' : {
        'reviews': {
          '$reviewIndex': {
            'rating': reviewRating,
            'comment': review,
            'user': user,
          },
        },
        'reviews-rating': overallRating,
        'reviews-amount': reviewIndex,
      },
    },SetOptions(merge: true),
    );
  }

  Future addMember(
      String category,
      int currentShopIdx,
      int memberIndex,
      String membershipType,
      String memberName,
      String memberEmail,
      int day,
      int month,
      int year,
      ) async {
    return await shops.doc(category).set({
      '$currentShopIdx' : {
        'members': {
          '$memberIndex': {
            'name': memberName,
            'email': memberEmail,
            'membership-type': membershipType,
            'start-day': day,
            'start-month': month,
            'start-year': year,
          },
        },
        'members-amount': memberIndex,
      },
    },SetOptions(merge: true),
    );
  }


  Future signUpUser(String name,String email, String phoneNumber,String password, int userIndex) async {
    return await users.doc("signed-up").set({
      '$userIndex' : {
        'appointment-amount': -1,
        'notification-amount': -1,
        'membership-amount': -1,
        'memberships': {},
        'notifications': {},
        'appointments': {},
        'full-name': name,
        'phone-number': phoneNumber,
        'email': email,
        'password': password,
        'user-index': userIndex,
      },
      'total-user-amount': userIndex,
    },SetOptions(merge: true),
    );
  }

  Future addUserMembership(
      int userIndex,
      int membershipIndex,
      String membershipName,
      String membershipShop,
      int day,
      int month,
      int year,
      ) async {
    return await users.doc("signed-up").set({
      '$userIndex' : {
        'membership-amount': membershipIndex,
        'memberships': {
          '$membershipIndex': {
            'membership-name': membershipName,
            'membership-shop': membershipShop,
            'start-day':day,
            'start-month': month,
            'start-year': year,
          },
        },
      },
    },SetOptions(merge: true),
    );
  }

  Future updateUserAppointments(int appointmentIndex,
      int userIndex,
      String dateBooked,
      String serviceBooked,
      String placeBooked,
      String durationBooked,
      String memberName,
      String servicePrice,
      String startTime,
      String endTime,
      int startDay,
      int startMonth,
      int startYear,
      String placeLogo,
      ) async {
    return await users.doc("signed-up").set({
      '$userIndex' : {
        'appointments':{
          '$appointmentIndex': {
            'appointment-status':true,
            'date-booked': dateBooked,
            'service-booked': serviceBooked,
            'place-booked': placeBooked,
            'duration-booked': durationBooked,
            'index': appointmentIndex,
            'member-name': memberName,
            'service-price': servicePrice,
            'start-time': startTime,
            'end-time': endTime,
            'start-day': startDay,
            'start-month': startMonth,
            'start-year': startYear,
            'place-logo': placeLogo,
          },
        },
        'appointment-amount':appointmentIndex,
      },
    },SetOptions(merge: true),
    );
  }

  Future updateNotificationStatus(
      int notificationIndex,
      int userIndex,
      ) async {
    return await users.doc("signed-up").set({
      '$userIndex' : {
        'notifications':{
          '$notificationIndex': {
            'viewed': true,
          },
        },
      },
    },SetOptions(merge: true),
    );
  }



}