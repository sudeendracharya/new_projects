import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AreaList with ChangeNotifier {
  // var baseUrl = 'https://demoeazybill.herokuapp.com/';
  // var baseUrl = 'https://samasthadeeparednet.herokuapp.com/';
  List _areaList = [];

  List get listArea {
    return _areaList;
  }

  Future<void> getAreList(var token) async {
    final Url = Uri.parse('${baseUrl}customer/getAreasName');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('areaList')) {
      try {
        final responseData = await http.get(
          Url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
        );

        var response = json.decode(responseData.body);
        // print(responseData.statusCode);
        // print(response);
        _areaList = response;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final areaList = json.encode(
          {
            'areaList': response,
          },
        );
        prefs.setString('areaList', areaList);
        // return response;
      } catch (e) {
        rethrow;
      }
    } else {
      final extratedAreaList =
          //we should use dynamic as a another value not a Object
          json.decode(prefs.getString('areaList'));

      _areaList = extratedAreaList['areaList'];
      notifyListeners();
    }
  }
}
