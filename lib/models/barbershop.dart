
class Barbershop {
  final String name;
  final int id;
  final String address;
  final String profession;
  final String image;
  final String rating;
  final String description;
  final List<String> employeeNames;
  final List<String> employeeRatings;
  final List<String> employeeImages;
  final List<String> timings;
  final List<bool> available;
  final employeeAmount;
  final shopIndex;
  Barbershop(
      {required this.timings,
        required this.id,
        required this.shopIndex,
        required this.profession,
        required this.employeeRatings,
        required this.employeeImages,
        required this.employeeNames,
        required this.employeeAmount,
        required this.address,
        required this.description,
        required this.image,
        required this.name,
        required this.rating,
        required this.available,
      });
}

var barberServiceList = [
  {'title': 'Men\s Haircut', 'duration': '45', 'price': '30'},
  {'title': 'Men\s Haircut & Beard Trim', 'duration': '60', 'price': '50'},
  {'title': 'Beard Trim', 'duration': '30', 'price': '75'},
  {'title': 'Shaving', 'duration': '30', 'price': '75'},
];

List<Barbershop> bestList = [
  Barbershop(
    id: 0,
    shopIndex: 0,
    name: "Mohamed & Ramy",
    address: "Almazah, Heliopolis",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    image: "assets/all_images/Mohamed.jpg",
    rating: "4.2",
    employeeAmount: 5,
    employeeNames: ["Anybody","Ahmed", "Omar", "Youssef", "Ziad"],
    employeeRatings: ["4.5","4.8","4.9"],
    employeeImages: ["assets/all_images/Mohamed.jpg","assets/all_images/male1.jpg","assets/all_images/male3.png", "assets/all_images/male2.jpg","assets/all_images/male1.jpg"],
    profession: "Barber",
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
    available: [true,true,true,true,true,true,true,true,true,true,true,true,true,],
  ),
  Barbershop(
    id: 1,
    shopIndex: 1,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    employeeImages: ["assets/all_images/bekky.PNG","assets/all_images/male3.png","assets/all_images/male4.jpeg","assets/all_images/male1.jpg"],
    name: "Bekky Barber",
    address: "Cairo Festival City Mall",
    description: "Outstanding men hairdressers salons through out Egypt and soon the Middle East, elevating and upscaling the field to finally serve you with the best.",
    image: "assets/all_images/bekky.PNG",
    rating: "4.8",
    employeeAmount: 4,
    employeeNames: ["Anybody","Omar", "Tarek", "Mohamed"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
    available: [true,true,true,true,true,true,true,true,true,true,true,true,true,],
  ),
  Barbershop(
    id: 2,
    shopIndex: 2,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    employeeImages: ["assets/all_images/Ahmed.PNG","assets/all_images/male1.jpg","assets/all_images/male3.png", "assets/all_images/male2.jpg"],
    name: "Ahmed & Abdou Beauty Center",
    address: "Nadi Al Saeed, Dokki",
    description:
    "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    image: "assets/all_images/ahmedandabdou.png",
    rating: "4.6",
    employeeAmount: 5,
    employeeNames: ["Anybody","Ahmed", "Ziad", "Youssef", "Ziad"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
    available: [true,true,true,true,true,true,true,true,true,true,true,true,true,],

  ),
  Barbershop(
    id: 3,
    shopIndex: 3,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    employeeImages: ["assets/all_images/Hesham.PNG","assets/all_images/male1.jpg","assets/all_images/male3.png", "assets/all_images/male2.jpg"],
    name: "Hesham Rabea",
    address: "El Merghany, Heliopolis",
    description:
    "sint suscipit perspiciatis velit dolorum rerum ipsa laboriosam odio",
    image: "assets/all_images/Hesham.PNG",
    rating: "4.4",
    employeeAmount: 4,
    employeeNames: ["Anybody","Omar", "Ahmed", "Youssef"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
    available: [true,true,true,true,true,true,true,true,true,true,true,true,true,],
  ),
  Barbershop(
    id: 4,
    shopIndex: 4,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    employeeImages: ["assets/all_images/El_Sagheer.jpg","assets/all_images/male1.jpg","assets/all_images/male3.png", "assets/all_images/male2.jpg"],
    name: "El Sagheer Salon",
    address: "Salah El-Deen, Zamalek",
    description: "fugit voluptas sed molestias voluptatem provident",
    image: "assets/all_images/El_Sagheer.jpg",
    rating: "4.9",
    employeeAmount: 5,
    employeeNames: ["Anybody","Tarek", "Omar", "Youssef", "Ziad"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
    available: [true,true,true,true,true,true,true,true,true,true,true,true,true,],
  ),
];

List<Barbershop> barbershopList = [
  Barbershop(
    id: 6,
    shopIndex: 6,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    employeeImages: ["assets/all_images/Ahmed.PNG","assets/all_images/Ahmed.PNG","assets/all_images/Ahmed.PNG"],
    name: "Ahmed & Abdou Beauty Center",
    address: "Nadi Al Saeed, Dokki",
    description:
    "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    image: "assets/all_images/ahmedandabdou.png",
    rating: "4.2",
    employeeAmount: 2,
    employeeNames: ["Anybody","Yaseen", "Mohammed", "Youssef", "Ziad"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
    available: [true,true,true,true,true,true,true,true,true,true,true,true,true,],
  ),];
  /*Barbershop(
    id: 6,
    shopIndex: 6,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    barberImages: ["assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg"],
    name: "Gent's Classic Cut",
    address: "1985  Platinum Drive",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    image: "assets/all_images/24.png",
    rating: "4.8",
    employeeAmount: 4,
    employeeNames: ["Anybody","Ahmed", "Janna", "Youssef"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  Barbershop(
    id: 7,
    shopIndex: 7,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    barberImages: ["assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg"],
    name: "Baylee The Barber",
    address: "546  New Street",
    description: "dolorem eum magni eos aperiam quia",
    image: "assets/all_images/attachment_115080175.jpg",
    rating: "4.4",
    employeeAmount: 4,
    employeeNames: ["Anybody","Ahmed", "Janna", "Youssef"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  Barbershop(
    id: 8,
    shopIndex: 8,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    barberImages: ["assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg"],
    name: "Gent's Classic Cut",
    address: "1985  Platinum Drive",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    image: "assets/all_images/24.png",
    rating: "4.8",
    employeeAmount: 4,
    employeeNames: ["Anybody","Ahmed", "Janna", "Youssef"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),
  Barbershop(
    id: 9,
    shopIndex: 9,
    profession: "Barber",
    employeeRatings: ["4.5","4.8","4.9"],
    barberImages: ["assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg","assets/all_images/barber-shop-_151212203429-563.jpg"],
    name: "We Are Barbershop",
    address: "1985 Kaizoku o ni",
    description: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    image: "assets/all_images/barbershop-logo_95982-25.jpg",
    rating: "4.8",
    employeeAmount: 4,
    employeeNames: ["Anybody","Ahmed", "Janna", "Youssef"],
    timings: [  '9:00', '9:15', '9:30', '9:45', '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00',],
  ),*/