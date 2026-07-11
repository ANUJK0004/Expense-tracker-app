import 'package:flutter/cupertino.dart';
enum Currency { rupee, dollar, euro, pound }

class SettingsController extends ChangeNotifier{
  Currency currency  = Currency.rupee;
  void changeCurrency(Currency newCurrency){
    currency = newCurrency;
    notifyListeners();
  }
}
