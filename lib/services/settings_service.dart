import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService._();

  static final SettingsService instance = SettingsService._();

  static const String currencyKey = "currency";
  static const String dateFormatKey = "date_format";
  static const String analyticsFilterKey = "analytics_filter";

  Future<void> saveCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(currencyKey, currency);
  }

  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(currencyKey) ?? "₹";
  }

  Future<void> saveDateFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(dateFormatKey, format);
  }

  Future<String> getDateFormat() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(dateFormatKey) ?? "dd/MM/yyyy";
  }

  Future<void> saveAnalyticsFilter(String filter) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      analyticsFilterKey,
      filter,
    );
  }

  Future<String> getAnalyticsFilter() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      analyticsFilterKey,
    ) ??
        "Monthly";
  }


}
