import 'package:booking_app/constants.dart';
import 'package:flutter/material.dart';

class Category {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  Category({required this.icon,required this.subtitle,required this.title,required this.color});
}

List<Category> categoryList = [
  Category(
    icon: "assets/all_images/saloon.svg",
    title: "Hair Salon",
    subtitle: "5",
    color: kPurple,
  ),
  Category(
    //assets/all_images/barberNEW.png,
    icon:'assets/all_images/haircut.svg',
    title: "Barbershop",
    subtitle: "59",
    color: kYellow,
  ),
  Category(
    icon: "assets/all_images/spa.svg",
    title: "Spa",
    subtitle: "15",
    color: kIndigo,
  ),
  Category(
    icon: "assets/all_images/gym_icon.svg",
    title: "Gym",
    subtitle: "15",
    color: kIndigo,
  ),
  Category(
    icon: "assets/all_images/pets-svgrepo-com.svg",
    title: "Pet Services",
    subtitle: "15",
    color: kIndigo,
  ),
  Category(
    icon: "assets/all_images/car-wash-svgrepo-com.svg",
    title: "Car Wash",
    subtitle: "15",
    color: kIndigo,
  ),
];