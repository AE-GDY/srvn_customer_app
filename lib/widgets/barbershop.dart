import 'package:booking_app/constants.dart';
import 'package:booking_app/models/barbershop.dart';
import 'package:flutter/material.dart';


class shopCard extends StatefulWidget {
  final String shopName;
  final String shopAddress;
  final String shopImageUrl;
  final String shopRating;
  final String category;
  final int shopIndex;
  shopCard({
    required this.shopName,
    required this.shopAddress,
    required this.shopImageUrl,
    required this.shopRating,
    required this.shopIndex,
    required this.category,
  });

  @override
  _shopCardState createState() => _shopCardState();
}

class _shopCardState extends State<shopCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      // color: Colors.red,
      margin: EdgeInsets.only(left: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: TextButton(
                onPressed: (){

                  currentShopIndex = widget.shopIndex;
                  currentCategory = widget.category;
                  currentShop = widget.shopName;
                  currentAddress = widget.shopAddress;

                  Navigator.pushNamed(context, '/currentshop');

                },
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.shopImageUrl,
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,

                    ),
                  ),
                ),
              ),
            ),
          ),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shopName,
                    overflow: TextOverflow.ellipsis,
                    style: kTitleItem,
                  ),

                  Text(
                      widget.shopAddress,
                      style: kSubtitleItem
                  ),
                ],
              ),

              Spacer(),
              Icon(
                Icons.star,
                size: 15.0,
                color: kYellow,
              ),
              Text('${widget.shopRating}', style: kTitleItem),
            ],
          ),

        ],
      ),
    );
  }
}