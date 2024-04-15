import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number) {
    final formattedNumber =
        NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'en')
            .format(number);
    return formattedNumber;
  }

  static String decimals(double number) {
    final formattedNumber =
        NumberFormat.decimalPatternDigits(decimalDigits: 1, locale: 'en')
            .format(number);
    return formattedNumber;
  }
}
