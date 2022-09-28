class SpaShop{
  final String name;
  final int id;
  final String address;
  final String image;
  final String profession;
  final String rating;
  final String description;
  final List<String> employeeNames;
  final List<String> employeeRatings;
  final List<String> employeeImages;
  final List<String> timings;
  final shopIndex;
  final employeeAmount;

  SpaShop({required this.timings,required this.id,required this.shopIndex,required this.profession,required this.name, required this.address, required this.image, required this.rating, required this.description, required this.employeeNames,
    required this.employeeRatings, required this.employeeImages, required this.employeeAmount
  });
}

var spaServiceList = [
  {'title': 'Men\s Treatment', 'duration': '45', 'price': '30'},
  {'title': 'Women\s Treatment', 'duration': '60', 'price': '50'},
  {'title': 'Pool and Sauna', 'duration': '25', 'price': '75'},
];

List<SpaShop> spaBestList = [
  SpaShop(
    id: 13,
    shopIndex: 0,
    profession: "Spa Employee",
    name: "Heavenly Spa",
    address: "Westin, New Cairo",
    image: "assets/all_images/Devarana.jpg", //
    rating: "4.9",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Malak", "Samar", "Rana"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/Westin.webp", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  SpaShop(
    id: 14,
    shopIndex: 1,
    profession: "Spa Employee",
    name: "Ghazal Health Center",
    address: "Fifth Settlement",
    image: "assets/all_images/Ghazal.PNG",
    rating: "4.8",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Farida", "Salma", "Habiba"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/Ghazal.PNG", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  SpaShop(
    id: 15,
    shopIndex: 2,
    profession: "Spa Employee",
    name: "Devarana Spa",
    address: "Dusit Thani, New Cairo",
    image: "assets/all_images/Westin.webp",
    rating: "4.6",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Malak", "Samar", "Rana"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/Devarana.jpg", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
];



List<SpaShop> spaList = [
  SpaShop(
    id: 13,
    shopIndex: 0,
    profession: "Spa Employee",
    name: "Heavenly Spa",
    address: "Westin, New Cairo",
    image: "assets/all_images/Devarana.jpg",
    rating: "4.9",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Malak", "Samar", "Rana"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/Westin.webp", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  SpaShop(
    id: 14,
    shopIndex: 1,
    profession: "Spa Employee",
    name: "Ghazal Health Center",
    address: "Fifth Settlement",
    image: "assets/all_images/Westin.webp", //
    rating: "4.8",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Farida", "Salma", "Habiba"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/Ghazal.PNG", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  SpaShop(
    id: 15,
    shopIndex: 2,
    profession: "Spa Employee",
    name: "Devarana Spa",
    address: "Dusit Thani, New Cairo",
    image: "assets/all_images/Ghazal.PNG", //
    rating: "4.6",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Malak", "Samar", "Rana"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/Devarana.jpg", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  SpaShop(
    id: 16,
    shopIndex: 3,
    profession: "Spa Employee",
    name: "Mandara Spa",
    address: "JW Marriott, Ring Rd.",
    image: "assets/all_images/JW.webp",
    rating: "4.3",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Laila", "Lara", "Salma"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/JW.webp", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),SpaShop(
    id: 17,
    shopIndex: 4,
    profession: "Spa Employee",
    name: "NEV Spa & Wellness",
    address: "CFC, New Cairo",
    image: "assets/all_images/Nev.jpg",
    rating: "4.8",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    employeeNames: ["Anybody","Salma", "Raghda", "Rana"],
    employeeRatings: ["4.6", "4.7", "4.8"],
    employeeImages: ["assets/all_images/Nev.jpg", "assets/all_images/female4.jpg", "assets/all_images/female5.jpg", "assets/all_images/female3.jpg"],
    employeeAmount: 4,
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
];