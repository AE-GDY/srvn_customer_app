

class Shop{

  String shopName;
  String shopAddress;
  String imageUrl;
  int shopReviewAmount;
  dynamic shopRating;
  String shopCategory;
  int shopIndex;

  Shop(
      {
        required this.shopName,
        required this.imageUrl,
        required this.shopAddress,
        required this.shopReviewAmount,
        required this.shopRating,
        required this.shopCategory,
        required this.shopIndex,
      });

}