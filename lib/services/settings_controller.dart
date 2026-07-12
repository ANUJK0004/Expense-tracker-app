import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsController extends ChangeNotifier {
  String _currency = "₹";

  String get currency => _currency;

  String _dateFormat = "dd/MM/yyyy";

  String get dateFormat => _dateFormat;

  String _analyticsFilter = "Monthly";

  String get analyticsFilter => _analyticsFilter;


  Future<void> loadSettings() async {

    _currency =
    await SettingsService.instance.getCurrency();

    _dateFormat =
    await SettingsService.instance.getDateFormat();

    _analyticsFilter =
    await SettingsService.instance.getAnalyticsFilter();

    notifyListeners();
  }

  Future<void> changeCurrency(String currency) async {
    _currency = currency;

    await SettingsService.instance.saveCurrency(currency);

    notifyListeners();
  }

  Future<void> changeDateFormat(String format) async {

    _dateFormat = format;

    await SettingsService.instance
        .saveDateFormat(format);

    notifyListeners();
  }

  Future<void> changeAnalyticsFilter(
      String filter) async {

    _analyticsFilter = filter;

    await SettingsService.instance
        .saveAnalyticsFilter(filter);

    notifyListeners();
  }
}
