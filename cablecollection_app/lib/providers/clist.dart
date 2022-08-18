import 'dart:convert';
import 'dart:io';

import 'package:cablecollection_app/providers/blist.dart';
import 'package:cablecollection_app/providers/customer.dart';
import 'package:cablecollection_app/providers/report.dart';
import 'package:cablecollection_app/providers/reportlist.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class CustomerList with ChangeNotifier {
  List<Customer> _list = [];
  List<Report> _yearlyReportList = [];

  List _areaList = [];

  List get listArea {
    return _areaList;
  }

  List get customerList {
    return _list;
  }

  static Map<String, dynamic> cusData;

  var _authToken;
  var cuid;
  CustomerList([this._authToken]);
  // var baseUrl = 'https://samasthadeeparednet.herokuapp.com/';
  // var baseUrl = 'https://demoeazybill.herokuapp.com/';

  List areaList = [];
  List areaDetails = [];

  List<Customer> get areaListData {
    return [...?areaList];
  }

  List<Customer> get areaDetailsData {
    return [...?areaDetails];
  }

  List<Customer> get list {
    return [...?_list];
  }

  Customer findById(String id) {
    // if (id != '') {
    return _list.firstWhere((element) => element.cuId == id);
    // }
    // return null;
  }

  void compareNumber(int num) {
    Customer c1 = _list.firstWhere((element) => element.mobile == num);
    cuid = c1.cuId;
    print(cuid);
    BillList.cusId = cuid;

    ReportList.cusId = cuid;
  }

  List<Report> get yearlyReportList {
    return [...?_yearlyReportList];
  }

  Future<int> addCustomer(Customer details, var token) async {
    final url = Uri.parse('${baseUrl}customer/addcustomer');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({
          'id': details.id,
          'Name': details.name,
          'Mobile': details.mobile,
          'Email': details.email,
          'Address': details.address,
          'AadharNumber': details.aadharnumber,
          'StbId': details.stbId,
          'SmartCardNumber': details.smartCardNumber,
          'Packages': details.packages,
          'PackageAmount': details.packageAmount,
          'Status': details.status,
          'Node': details.node,
          'Due': details.due,
          'Advance': details.advance,
          'StbMaterial': details.stbMaterial,
          'Area': details.area,
          'TV': details.tv,
          'SubscriptionEndDate': details.subscriptionEndDate,
        }),
      );
      print(response.statusCode);
      // print(response.body);
      final newCustomer = Customer(
        cuId: json.decode(response.body)['name'],
        id: details.id,
        name: details.name,
        mobile: details.mobile,
        smartCardNumber: details.smartCardNumber,
        area: details.area,
        node: details.node,
        address: details.address,
        stbId: details.stbId,
        tv: details.tv,
        packages: details.packages,
        packageAmount: details.packageAmount,
        email: details.email,
        aadharnumber: details.aadharnumber,
        stbMaterial: details.stbMaterial,
        due: details.due,
        advance: details.advance,
        status: details.status,
        subscriptionEndDate: details.subscriptionEndDate,
      );
      _list.add(newCustomer);
      return response.statusCode;
      // fetchAndSetCustomer();
    } catch (error) {
      print(error);
    }
    return 500;

    // notifyListeners();
  }

  Future<int> updateCustomer(
      var id, Customer updatingCustomer, var token) async {
    final url = Uri.parse('${baseUrl}customer/editcustomer');

    try {
      var response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode(
          {
            'cuId': id,
            'AadharNumber': updatingCustomer.aadharnumber,
            'Address': updatingCustomer.address,
            'Advance': updatingCustomer.advance,
            'Area': updatingCustomer.area,
            'Due': updatingCustomer.due,
            'Email': updatingCustomer.email,
            'Mobile': updatingCustomer.mobile,
            'Name': updatingCustomer.name,
            'Node': updatingCustomer.node,
            'PackageAmount': updatingCustomer.packageAmount,
            'Packages': updatingCustomer.packages,
            'SmartCardNumber': updatingCustomer.smartCardNumber,
            'Status': updatingCustomer.status,
            'StbId': updatingCustomer.stbId,
            'stb mateirial': updatingCustomer.stbMaterial,
            'TV': updatingCustomer.tv,
            'id': updatingCustomer.id,
          },
        ),
      );

      print(response.statusCode);
      return response.statusCode;
    } catch (e) {}

    return 500;
  }

//Store
  Future<List<Customer>> fetchAndSetCustomer(var token) async {
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
        return [];
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
        _list = loadedCustomers;
        notifyListeners();
        return loadedCustomers;
      }
    } catch (error) {
      rethrow;
    }
  }

  Map<String, dynamic> display(Map<String, dynamic> value) {
    return value;
  }

  Future<Map<String, dynamic>> fetchCustomerDetails(
      String cuid, var token) async {
    print(cuid);
    final url = Uri.parse('${baseUrl}customer/getacustomer/$cuid');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      if (json.decode(response.body) == null) {
        return null;
      } else {
        // print(response.body);
        final extratedData = json.decode(response.body) as Map<String, dynamic>;

        return extratedData;
      }
    } catch (error) {
      rethrow;
    }
  }

  //bill/addbill

  // Future<Map<String, dynamic>> fetchCustomerBill(String cuid) async {
  //   print(cuid);
  //   final url = Uri.parse(
  //       'https://cable-app-f9308-default-rtdb.firebaseio.com/CustomerList/$cuid.json');
  //   try {
  //     final response = await http.get(url);

  //     if (json.decode(response.body) == null) {
  //       return null;
  //     } else {
  //       final extratedData = json.decode(response.body) as Map<String, dynamic>;

  //       return extratedData;
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<int> deleteCustomer(var id, var token) async {
    final url = Uri.parse('${baseUrl}customer/deletecustomer/$id');

    try {
      final Response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      print(Response.statusCode);
      print(Response.body);
      return Response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  // Future<dynamic> uploadPdf(File image) async {
  //   var uri = Uri.parse(
  //       'https://cable-app-f9308-default-rtdb.firebaseio.com/store.json');
  // }

  //  FilePickerResult _file;

  //                 Future getfile() async {
  //                   FilePickerResult file =
  //                       await FilePicker.platform.pickFiles();
  //                   setState(() {
  //                     _file = file;
  //                   });
  //                 }

  //                 Future<void> _uploadFile(filePath) async {
  //                   String fileName = basename(filePath.path);
  //                   print('file base name:$fileName');

  //                   try {
  //                     FormData formData = new FormData.fromMap({
  //                       "name": "rajika",
  //                       "age": 22,
  //                       "file": await MultipartFile.fromFile(filePath.path,
  //                           filename: fileName),
  //                     });
  //                   } catch (e) {}
  //                 }

  Future<Map<String, dynamic>> customerOverViewScreen(var token) async {
    final url = Uri.parse('${baseUrl}customer/allareas');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var data = json.decode(response.body) as List;

      List allAreaValues = [];
      List allAreas = [];
      int totalActive = 0;
      int totalInactive = 0;
      int totalStore = 0;

      for (var value in data) {
        allAreas.add(
          value['Area'].toString(),
        );
        totalActive = totalActive + value['Active'];
        totalInactive = totalInactive + value['InActive'];
        totalStore = totalStore + value['Store'];
        allAreaValues.add({
          'Area': value['Area'],
          'Node': value['Node'],
          'Active': value['Active'],
          'InActive': value['InActive'],
          'Store': value['Store'],
        });
      }
      List result = [
        ...{...allAreas}
      ];
      areaList = result;
      areaDetails = allAreaValues;
      List<Map<String, dynamic>> activeInactive = [];

      for (int i = 0; i < result.length; i++) {
        int active = 0;
        int inactive = 0;
        int store = 0;

        for (int j = 0; j < allAreaValues.length; j++) {
          if (result[i] == allAreaValues[j]['Area']) {
            active = active + allAreaValues[j]['Active'];
            inactive = inactive + allAreaValues[j]['InActive'];
            store = store + allAreaValues[j]['Store'];
          }
        }
        activeInactive.add({
          'area': result[i],
          'active': active,
          'inactive': inactive,
          'store': store,
        });
      }

      //notifyListeners();
      // print('$totalActive,$totalInactive,$totalStore');
      // print(activeInactive.toString());
      // print(result.toString());
      // log(allAreas.toString());
      // log(allAreaValues.toString());

      print(response.statusCode);

      // log(response.body);
      return {
        'areaList': result,
        'areaDetails': allAreaValues,
        'areaValues': activeInactive,
        'totalActive': totalActive,
        'totalInactive': totalInactive,
        'totalStore': totalStore,
      };
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<List<Customer>> fetchAndSetCustomerStore(var token) async {
    final Url = Uri.parse('${baseUrl}customer/allcustomer/store');

    try {
      final responseData = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var extratedData = json.decode(responseData.body);

      print(responseData.statusCode);
      print(responseData.body);
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
      _list = loadedCustomers;
      return loadedCustomers;
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<int> addToDo(var data, var token) async {
    final Url = Uri.parse('${baseUrl}todo/addtodo');
    // print(data);

    try {
      final response = await http.post(Url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
          body: json.encode({
            'title': data['title'],
            'description': data['description'],
            'date': data['date'],
          }));

      //print(response.statusCode);
      //  print(response.body);
      return response.statusCode;
    } catch (e) {
      print(e);
    }
    return 500;
  }

  Future<List> fetchToDo(var token) async {
    final Url = Uri.parse('${baseUrl}todo/alltodos');
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
      //  print(response);
      return response;
    } catch (e) {}
    return [];
  }

  Future<int> editToDo(var data, var token) async {
    final Url = Uri.parse('${baseUrl}todo/edittodo');

    try {
      final responseData = await http.patch(Url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
          body: json.encode({
            'tuId': data['tuId'],
            'title': data['title'],
            'description': data['description'],
            'date': data['date'],
          }));

      // print(responseData.statusCode);
      return responseData.statusCode;
    } catch (e) {}
    return 500;
  }

  Future<int> deleteToDo(var tuId, var token) async {
    final Url = Uri.parse('${baseUrl}todo/deletetodo/$tuId');

    try {
      final responseData = await http.delete(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      //  print(responseData.statusCode);
      return responseData.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addComplaints(var data, var token) async {
    final Url = Uri.parse('${baseUrl}complaint/addcomplaint');
    try {
      final responseData = await http.post(Url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
          body: json.encode({
            'title': data['title'],
            'description': data['description'],
            'date': data['date'],
            'cuId': data['cuId'],
          }));

      // print(responseData.statusCode);
      //  print(responseData.body);
      return responseData.statusCode;
    } catch (e) {}
  }

  Future<List> fetchSingleCustomerComplaint(var cuId, var token) async {
    final Url = Uri.parse('${baseUrl}complaint/getcomplaints/$cuId');
    try {
      final responseData = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var response = json.decode(responseData.body);

      //print(responseData.statusCode);
      //(responseData.body);
      return response;
    } catch (e) {}
    return [];
  }

  Future<List> fetchAllComplaints(var token) async {
    final Url = Uri.parse('${baseUrl}complaint/allcomplaint');
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
      // print(responseData.body);
      return response;
    } catch (e) {}
    return [];
  }

  Future<int> editComplaint(var data, var token) async {
    final Url = Uri.parse('${baseUrl}complaint/editcomplaint');
    try {
      final responseData = await http.patch(Url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
          body: json.encode({
            'compId': data['compId'],
            'title': data['title'],
            'description': data['description'],
            'date': data['date'],
          }));

      var response = json.decode(responseData.body);

      // print(responseData.statusCode);
      return responseData.statusCode;
    } catch (e) {}
    return 500;
  }

  Future<int> deleteComplaint(var compId, var token) async {
    final Url = Uri.parse('${baseUrl}complaint/deletecomplaint/$compId');
    try {
      final responseData = await http.delete(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var response = json.decode(responseData.body);

      // print(responseData.statusCode);
      return responseData.statusCode;
    } catch (e) {}
    return 500;
  }

  Future<List> getAreaWiseCustomerList(var areaName, var token) async {
    final Url = Uri.parse('${baseUrl}customer/getCustomersByArea/$areaName');

    try {
      final responseData = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var response = json.decode(responseData.body);
      final List<Customer> loadedCustomers = [];
      for (var data in response) {
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
      // print(responseData.body);
      return loadedCustomers;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCustomerBillingDetails(
      String cuid, var token) async {
    print(cuid);
    final url = Uri.parse('${baseUrl}customer/getcustomerlastpaid/$cuid');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      if (json.decode(response.body) == null) {
        return null;
      } else {
        print(response.statusCode);
        print(response.body);
        final extratedData = json.decode(response.body) as Map<String, dynamic>;
        Map<String, dynamic> customerData = {
          'id': extratedData['stb']['id'],
          'name': extratedData['stb']['Name'],
          'number': extratedData['stb']['Mobile'],
          'smartCardNumber': extratedData['stb']['SmartCardNumber'],
          'packageAmount': extratedData['stb']['PackageAmount'],
          'paidAmount': extratedData['PaidAmount'] == null
              ? '0'
              : extratedData['PaidAmount']['PaidAmount'].toString(),
        };

        return customerData;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List> getNodeWiseCustomerList(
      var areaName, var node, var token) async {
    final Url =
        Uri.parse('${baseUrl}customer/getCustomersByNode/$areaName/$node');

    try {
      final responseData = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var response = json.decode(responseData.body);
      print(responseData.statusCode);
      // print(response);
      final List<Customer> loadedCustomers = [];
      for (var data in response) {
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
      // print(responseData.body);
      return loadedCustomers;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAreList(var token) async {
    final Url = Uri.parse('${baseUrl}customer/getAreasName');
    try {
      final responseData = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var response = json.decode(responseData.body);
      print(responseData.statusCode);
      print(response);
      _areaList = response;
      notifyListeners();
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> refresh(var date, var token) async {
    print('refresh');
    final Url = Uri.parse('${baseUrl}customer/resetStatus');
    try {
      final responseData = await http.post(Url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
          body: json.encode({'today': date}));

      var response = json.decode(responseData.body);

      print(responseData.statusCode);
      print(response);
      return responseData.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  ///customer/deletecustomer/id

  //getcustomerlastpaid
}
