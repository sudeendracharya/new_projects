import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/barber_details.dart';
import 'package:salon/providers/business.dart';
import 'package:salon/screens/map_screen.dart';

import '../barber_shop.dart';

class ExploreShopListScreenDesignTwo extends StatefulWidget {
  ExploreShopListScreenDesignTwo({Key? key}) : super(key: key);

  @override
  _ExploreShopListScreenDesignTwoState createState() =>
      _ExploreShopListScreenDesignTwoState();
}

class _ExploreShopListScreenDesignTwoState
    extends State<ExploreShopListScreenDesignTwo> {
  var isloading = true;
  Uint8List? image;
  List<Business> barberList = [];
  var token;

  @override
  void initState() {
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
    super.initState();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  List<String> selected = [];

  TextStyle filterStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12));
  }

  @override
  Widget build(BuildContext context) {
    barberList = Provider.of<ApiCalls>(context).barberShopsList;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(barberList);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width - 30,
                  height: 40,
                  decoration: BoxDecoration(border: Border.all()),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 3),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black87,
                              ),
                              hintText: 'Search',
                              hintStyle: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(MapScreen.routeName);
                        },
                        child: Container(
                          width: 50,
                          height: 30,
                          child: Image.asset('assets/images/map.png'),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Container(
                          width: 46,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.filter_alt_sharp)
                          // Image.asset(
                          //   'assets/images/settings.png',
                          //   width: 20,
                          //   height: 10,
                          //   alignment: Alignment.center,

                          //   // fit: BoxFit.contain,
                          // ),
                          ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                            width: 92,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(16)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Featured',
                                  style: filterStyle(),
                                ),
                                const Icon(Icons.keyboard_arrow_down_sharp)
                              ],
                            )
                            //  DropDownMultiSelect(
                            //     decoration: InputDecoration(border: InputBorder.none),
                            //     isDense: true,
                            //     options: [
                            //       'Feature 1',
                            //       'Feature 2',
                            //       'Feature 3',
                            //       'Feature 4'
                            //     ],
                            //     selectedValues: selected,
                            //     onChanged: (List<String> x) {
                            //       setState(() {
                            //         selected = x;
                            //       });
                            //     },
                            //     whenEmpty: 'Select Feature'),
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Container(
                            width: 92,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(16)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Distance',
                                  style: filterStyle(),
                                ),
                                const Icon(Icons.keyboard_arrow_down_sharp)
                              ],
                            )
                            //  DropDownMultiSelect(
                            //     decoration: InputDecoration(border: InputBorder.none),
                            //     isDense: true,
                            //     options: [
                            //       'Feature 1',
                            //       'Feature 2',
                            //       'Feature 3',
                            //       'Feature 4'
                            //     ],
                            //     selectedValues: selected,
                            //     onChanged: (List<String> x) {
                            //       setState(() {
                            //         selected = x;
                            //       });
                            //     },
                            //     whenEmpty: 'Select Feature'),
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                            width: 92,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(16)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Rating',
                                  style: filterStyle(),
                                ),
                                const Icon(Icons.keyboard_arrow_down_sharp)
                              ],
                            )
                            //  DropDownMultiSelect(
                            //     decoration: InputDecoration(border: InputBorder.none),
                            //     isDense: true,
                            //     options: [
                            //       'Feature 1',
                            //       'Feature 2',
                            //       'Feature 3',
                            //       'Feature 4'
                            //     ],
                            //     selectedValues: selected,
                            //     onChanged: (List<String> x) {
                            //       setState(() {
                            //         selected = x;
                            //       });
                            //     },
                            //     whenEmpty: 'Select Feature'),
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: barberList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return IndividualBarberShops(
                        key: UniqueKey(),
                        name: barberList[index].businessName,
                        address:
                            '${barberList[index].city},${barberList[index].street},${barberList[index].state},${barberList[index].country},${barberList[index].zipCode}',
                        image: barberList[index].imagepath,
                        id: barberList[index].id,
                        description: barberList[index].description,
                        index: barberList[index].index,
                        token: token ?? '',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IndividualBarberShops extends StatefulWidget {
  const IndividualBarberShops(
      {Key? key,
      required this.name,
      required this.address,
      required this.image,
      required this.id,
      required this.description,
      required this.index,
      required this.token})
      : super(key: key);

  final String name;
  final String address;
  final List image;
  final String id;
  final String description;
  final int index;
  final String token;

  @override
  _IndividualBarberShopsState createState() => _IndividualBarberShopsState();
}

class _IndividualBarberShopsState extends State<IndividualBarberShops> {
  TextStyle shopNameStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 22,
            color: Color.fromRGBO(0, 0, 0, 1)));
  }

  TextStyle shopDescriptionStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: Color.fromRGBO(79, 79, 79, 1),
      ),
    );
  }

  TextStyle timingsStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 8,
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BarberDetails.id = widget.id;
        Navigator.of(context).pushNamed(BarberShopDetails.routeName,
            arguments: {
              'index': widget.index,
              'token': widget.token,
              'image': widget.image
            });
      },
      child: Container(
        height: 199,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,

                      // width: 400,
                      imageUrl: widget.image[0],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.5),
                      child: Text(
                        widget.name,
                        style: shopNameStyle(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.5),
                      child: Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Color.fromRGBO(79, 79, 79, 1),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '379 Reviews',
                              style: shopDescriptionStyle(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.5),
                      child: Container(
                          width: 140,
                          height: 40,
                          child: Text(
                            widget.description,
                            style: shopDescriptionStyle(),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.5),
                      child: Text(
                        widget.address,
                        style: shopDescriptionStyle(),
                      ),
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 57,
                            height: 22,
                            color: Color.fromRGBO(79, 79, 79, 1),
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(6),
                            // ),
                            child: Text(
                              '6:00 PM',
                              style: timingsStyle(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 57,
                            height: 22,
                            color: Color.fromRGBO(79, 79, 79, 1),
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(6),
                            // ),
                            child: Text(
                              '6:30 PM',
                              style: timingsStyle(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 57,
                            height: 22,
                            color: const Color.fromRGBO(79, 79, 79, 1),
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(6),
                            // ),
                            child: Text(
                              '7:00 PM',
                              style: timingsStyle(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Divider(
                thickness: 1,
                color: Color.fromRGBO(189, 189, 189, 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
