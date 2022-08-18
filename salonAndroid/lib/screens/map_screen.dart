import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/business.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key, this.lattitude, this.longitude}) : super(key: key);

  var lattitude;
  var longitude;
  static const routeName = '/MapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var shopName;
  var shopType;
  var shopAddress;
  var number;
  List<Marker> markers = [];

  bool _markerTapped = false;

  List<Business> barberList = [];
  @override
  void dispose() {
    mapController.dispose();

    super.dispose();
  }
  // Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
  var initialLatitude = 15.334880;
  var initialLongitude = 76.462044;
  var token;

  @override
  void initState() {
    initilize();
    super.initState();
    getMarker(initialLatitude, initialLongitude);
    _center = LatLng(40.79501287029067, -74.11884485258012);

    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        token = Provider.of<ApiCalls>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .getBarberShopsList(token)
            .then((value) {
          if (value == 200 || value == 201) {}
        });
      }
    });
  }

  initilize() {
    Marker firstMarker = Marker(
      markerId: const MarkerId('New Barber Shop'),
      position: const LatLng(40.738380, -73.988426),
      infoWindow: const InfoWindow(title: 'Gramercy Tavern'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
        setState(() {
          shopName = 'New Barber Shop';
          shopAddress = '26th Cross MR Road';
          shopType = 'Barber Shop';
          number = '7645784545';
          _markerTapped = true;
        });
      },
    );
    Marker secondMarker = Marker(
      markerId: const MarkerId('New Barbers'),
      position: const LatLng(40.761421, -73.981667),
      infoWindow: const InfoWindow(title: 'Le Bernardin'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
        setState(() {
          shopName = 'New Barbers';
          shopAddress = '26th Cross petersberg Road';
          shopType = 'Mens Barber Shop';
          number = '7845784545';
          _markerTapped = true;
        });
      },
    );
    Marker thirdMarker = Marker(
      markerId: const MarkerId('New Hair Styles'),
      position: const LatLng(40.732128, -73.999619),
      infoWindow: const InfoWindow(title: 'Blue Hill'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
        setState(() {
          shopName = 'New Hair Styles';
          shopAddress = '26th Cross Ysr Road';
          shopType = 'Salon Shop';
          number = '8945784545';
          _markerTapped = true;
        });
      },
    );
    Marker fourthMarker = Marker(
      markerId: const MarkerId('Modern Salon'),
      position: const LatLng(40.702128, -73.929619),
      infoWindow: const InfoWindow(title: 'High Hills'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
        setState(() {
          shopName = 'Modern Salon';
          shopAddress = '26th Cross HSN Road';
          shopType = 'Barber Shop';
          number = '9845784545';
          _markerTapped = true;
        });
      },
    );

    markers.add(firstMarker);
    markers.add(secondMarker);
    markers.add(thirdMarker);
    markers.add(fourthMarker);
    setState(() {});
  }

  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  void getMyLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation().then((value) {
      setState(() {
        double? lattitude = value.latitude;
        double? longitude = value.longitude;

        getMarker(value.latitude, value.longitude);
        _center = LatLng(lattitude!, longitude!);
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lattitude, longitude),
          zoom: 15.0,
        )));
      });
      return value;
    });

    print("locationLatitude: ${_locationData.latitude}");
    print("locationLongitude: ${_locationData.longitude}");
  }

  void getShopLocation(double latitude, double longitude) {
    setState(() {
      getMarker(latitude, longitude);
      _center = LatLng(latitude, longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 15.0,
      )));
    });
  }

  late GoogleMapController mapController;

  late LatLng _center;
  List<Marker> _origin = [];

  void getMarker(var latitude, var longitude) {
    Marker newMarker = Marker(
      markerId: const MarkerId('Barber Shop'),
      infoWindow: const InfoWindow(title: 'Barber Shop'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(latitude, longitude),
    );
    markers.add(newMarker);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<Map<String, dynamic>> locationList = [
    {'Latitude': 40.79501287029067, 'Longitude': -74.11884485258012},
    {'Latitude': 40.79266608689087, 'Longitude': -74.11996227912344},
    {'Latitude': 40.79857115221591, 'Longitude': -74.11884485258012},
    {'Latitude': 40.79501287029067, 'Longitude': -74.11884485258013},
    {'Latitude': 40.79749096041382, 'Longitude': -74.12370848769446},
    {'Latitude': 40.80049604077438, 'Longitude': -74.12195963856148},
    {'Latitude': 40.80348021485626, 'Longitude': -74.12055442876718},
    {'Latitude': 40.80523436131732, 'Longitude': -74.11884485258012},
    {'Latitude': 40.80078408243326, 'Longitude': -74.11806148633993},
    {'Latitude': 40.80324562082574, 'Longitude': -74.11360322199688},
    {'Latitude': 40.79711717083607, 'Longitude': -74.12483149197843},
  ];
  List<Marker> customMarkers = [];

  // List<Map<String, dynamic>> locationList = [];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    barberList = Provider.of<ApiCalls>(context).barberShopsList;
    // if (barberList.isNotEmpty) {
    //   // LatLng(40.738381, -73.988428);
    //   var latitude = 40.73838;
    //   var longitude = -73.98842;

    //   for (int i = 0; i < barberList.length; i++) {
    //     locationList
    //         .add({'Latitude': latitude + i, 'Longitude': longitude + i});
    //   }
    //   print(locationList);
    // }
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          GoogleMap(
            buildingsEnabled: true,
            mapType: MapType.normal,
            // indoorViewEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            // rotateGesturesEnabled: true,
            compassEnabled: true,
            markers: markers.map((e) => e).toSet(),
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialCameraPosition(),
          ),
          Positioned(
            bottom: height * 0.05,
            left: 0,
            child: Container(
              width: width,
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: barberList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        getShopLocation(locationList[index]['Latitude'],
                            locationList[index]['Longitude']);
                      },
                      child: BarberLocationDetails(
                          image: barberList[index].imagepath,
                          width: width,
                          height: height,
                          shopName: barberList[index].businessName,
                          shopType: 'shopType',
                          shopAddress: 'shopAddress',
                          number: 'number'),
                    ),
                  );
                },
              ),
            ),
          )
        ]),
      ),
      // floatingActionButton: _markerTapped == true
      //     ? SizedBox()
      //     : Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           FloatingActionButton.extended(
      //             heroTag: 'Focus',
      //             backgroundColor: Colors.black,
      //             onPressed: () => mapController.animateCamera(
      //                 CameraUpdate.newCameraPosition(_initialCameraPosition())),
      //             label: const Text('Focus!'),
      //             icon: const Icon(Icons.center_focus_strong),
      //           ),
      //           const SizedBox(
      //             width: 20,
      //           ),
      //           FloatingActionButton.extended(
      //             heroTag: 'Location',
      //             backgroundColor: Colors.black,
      //             onPressed: getMyLocation,
      //             label: const Text('My Location'),
      //             icon: const Icon(Icons.location_on_outlined),
      //           )
      //         ],
      //       ),
    );
  }

  CameraPosition _initialCameraPosition() {
    return CameraPosition(
      target: _center,
      zoom: 12,
    );
  }
}

class BarberLocationDetails extends StatelessWidget {
  const BarberLocationDetails({
    Key? key,
    required this.width,
    required this.height,
    required this.shopName,
    required this.shopType,
    required this.shopAddress,
    required this.number,
    required this.image,
  }) : super(key: key);

  final double width;
  final double height;
  final String shopName;
  final String shopType;
  final String shopAddress;
  final String number;
  final List image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width - 20,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      // color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: width * 0.33,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,

                    // width: 400,
                    imageUrl: image[0],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  shopName,
                  style: GoogleFonts.roboto(
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 22)),
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      unratedColor: Colors.white.withOpacity(0.5),
                      itemSize: 15,
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.grey,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    const Text('350 Reviews')
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('shopType')),
                    SizedBox(
                      width: width * 0.15,
                    ),
                    Text('\$\$')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 100, child: Text('shopAddress')),
                    SizedBox(
                      width: width * 0.11,
                    ),
                    Text('0.2 MI')
                  ],
                ),
                Text('number'),
                Row(
                  children: [
                    Container(
                      width: width * 0.13,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey),
                      child: const Center(
                        child: Text(
                          '6:00 PM',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: width * 0.13,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey),
                      child: const Center(
                        child: Text(
                          '6:30 PM',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: width * 0.13,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey),
                      child: const Center(
                        child: Text(
                          '7:00 PM',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
