

class CreditCard{


  String? cardCountry;
  String cardNumber;
  String cardExpiry;
  String cvc;
  String nickname;

  CreditCard(
      {
        required this.cardCountry,
        required this.cardNumber,
        required this.cardExpiry,
        required this.cvc,
        required this.nickname,
      }
      );
}