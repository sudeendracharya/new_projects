import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'customer.dart';
import 'package:http/http.dart' as http;

class AllCustomerList with ChangeNotifier {
  List<Customer> _list = [];
  List get customerList {
    return _list;
  }

  // var baseUrl = 'https://samasthadeeparednet.herokuapp.com/';
  Future<int> fetchAndSetCustomer(var token) async {
    final Url = Uri.parse('${baseUrl}customer/allcustomer/inUse');

    try {
      final responseData = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      if (json.decode(responseData.body) == null) {
        return 500;
      } else {
        final extratedData = json.decode(responseData.body);
        // print(' This is $extratedData');

        final List<Customer> loadedCustomers = [];
        for (var data in extratedData) {
          loadedCustomers.add(
            Customer(
              cuId: data['cuId'].toString(),
              //  id: prodData['id'],
              name: data['Name'],
              //   aadharnumber: prodData['AadharNumber'],
              //   address: prodData['Address'],
              //   advance: prodData['Advance'],
              // area: prodData['Area'],
              //  due: prodData['Due'],
              //   email: prodData['Email'],
              mobile: data['Mobile'],
              //  node: prodData['Node'],
              //  packageAmount: prodData['PackageAmount'],
              //  packages: prodData['Packages'],
              smartCardNumber: data['SmartCardNumber'],
              status: data['Status'],
              //  stbId: prodData['StbId'],
              //  stbMaterial: prodData['StbMaterial'],
              //  tv: prodData['TV'],
              subscriptionEndDate: data['SubscriptionEndDate'] == null
                  ? 'No End Date'
                  : data['SubscriptionEndDate'],
            ),
          );
        }
        // print(responseData.statusCode);
        _list = loadedCustomers;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final cusList = json.encode(
          {
            'list': extratedData,
          },
        );
        prefs.setString('cusList', cusList);
        return responseData.statusCode;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getLocalCusList() async {
    // logout();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cusList')) {
      print('getting online cusList');
      return false;
    }
    final extratedCusListData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('cusList'));

    final List<Customer> loadedCustomers = [];
    for (var data in extratedCusListData['list']) {
      loadedCustomers.add(
        Customer(
          cuId: data['cuId'].toString(),
          //  id: prodData['id'],
          name: data['Name'],
          //   aadharnumber: prodData['AadharNumber'],
          //   address: prodData['Address'],
          //   advance: prodData['Advance'],
          // area: prodData['Area'],
          //  due: prodData['Due'],
          //   email: prodData['Email'],
          mobile: data['Mobile'],
          //  node: prodData['Node'],
          //  packageAmount: prodData['PackageAmount'],
          //  packages: prodData['Packages'],
          smartCardNumber: data['SmartCardNumber'],
          status: data['Status'],
          //  stbId: prodData['StbId'],
          //  stbMaterial: prodData['StbMaterial'],
          //  tv: prodData['TV'],
          subscriptionEndDate: data['SubscriptionEndDate'] == null
              ? 'No End Date'
              : data['SubscriptionEndDate'],
        ),
      );
    }

    _list = loadedCustomers;

    notifyListeners();

    //  print(_token);
    return true;
  }
}
