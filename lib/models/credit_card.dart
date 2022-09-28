

class CreditCard{


  String cardCountry;
  String cardNumber;
  String cardMonthExpiry;
  String cardYearExpiry;
  String cvc;

  CreditCard(
      {
        required this.cardCountry,
        required this.cardNumber,
        required this.cardMonthExpiry,
        required this.cardYearExpiry,
        required this.cvc,
      }
      );
}