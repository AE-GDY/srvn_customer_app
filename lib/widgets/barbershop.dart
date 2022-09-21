import 'package:booking_app/constants.dart';
import 'package:booking_app/models/barbershop.dart';
import 'package:flutter/material.dart';


class shopCard extends StatefulWidget {
  final dynamic barbershop;
  final barberIndex;
  shopCard({required this.barbershop, required this.barberIndex});

  @override
  _shopCardState createState() => _shopCardState();
}

class _shopCardState extends State<shopCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      // color: Colors.red,
      margin: EdgeInsets.only(left: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: TextButton(
                onPressed: (){
                  setState(() {
                    currentShopIndex = widget.barberIndex;
                    onBarberShop = true;
                  });
                  Navigator.pushNamed(context, '/currentshop');
                  print("index: $barberShopIndex");
                },
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    image: DecorationImage(
                      image: AssetImage(widget.barbershop.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Row(
            children: [
              SizedBox(
                width: 140.0,
                child: Text(
                  widget.barbershop.name,
                  overflow: TextOverflow.ellipsis,
                  style: kTitleItem,
                ),
              ),
              Spacer(),
              Icon(
                Icons.star,
                size: 15.0,
                color: kYellow,
              ),
              Text(widget.barbershop.rating, style: kTitleItem),
            ],
          ),
          Text(widget.barbershop.address,
              overflow: TextOverflow.ellipsis, style: kTitleItem),
        ],
      ),
    );
  }
}