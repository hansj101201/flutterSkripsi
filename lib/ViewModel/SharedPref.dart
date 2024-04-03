import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getIdSalesFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? salesmanJson = prefs.getString('salesman');
  if (salesmanJson != null) {
    Map<String, dynamic> salesmanMap = jsonDecode(salesmanJson);
    return salesmanMap['ID_SALES'];
  }
  return null;
}
