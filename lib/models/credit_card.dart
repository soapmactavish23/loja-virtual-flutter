import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String number = "";
  String holder = "";
  String expirationDate = "";
  String secutiryCode = "";
  String brand = "";

  void setHolder(String? name) => holder = name!;
  void setExpirationDate(String? date) => expirationDate = date!;
  void setCVV(String? cvv) => secutiryCode = cvv!;
  void setNumber(String? number) {
    this.number = number!;
    brand = detectCCType(number.replaceAll(' ', '')).toString();
  }

  @override
  String toString() {
    return 'CreditCard(number: $number, holder: $holder, expirationDate: $expirationDate, secutiryCode: $secutiryCode, brand: $brand)';
  }
}
