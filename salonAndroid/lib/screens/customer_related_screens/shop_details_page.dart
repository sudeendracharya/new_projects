import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salon/screens/customer_related_screens/hair_cut_bookings_timing_page.dart';

class ShopDetailsPage extends StatefulWidget {
  ShopDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/ShopDetailsPage';

  @override
  _ShopDetailsPageState createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage>
    with SingleTickerProviderStateMixin {
  var leftPadding = 12;

  ScrollController controller = ScrollController();
  late TabController _tabController;

  var index;
  @override
  void initState() {
    // var index = Get.arguments;

    _tabController = TabController(
        vsync: this, length: myTabs.length, initialIndex: index ?? 0);

    super.initState();
  }

  static List<Tab> myTabs = <Tab>[
    Tab(
      child: Container(
        width: 32,
        height: 9,
        child: Text(
          'Bookings',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 8,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 32,
        height: 9,
        child: Text(
          'Offerings',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 8,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 32,
        height: 9,
        child: Text(
          'Reviews',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 8,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 32,
        height: 9,
        child: Text(
          'Details',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 8,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(height);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 212,
                color: const Color.fromRGBO(196, 196, 196, 1),
                child: Stack(
                  children: [
                    Positioned(
                        left: 12,
                        top: 17.5,
                        child: Row(
                          children: const [
                            Icon(Icons.chevron_left_outlined),
                            Text('Back')
                          ],
                        )),
                    Positioned(
                      bottom: 25,
                      left: width * 0.35,
                      child: Text('See All Photos'),
                    )
                  ],
                ),
              ),
              Container(
                height: 125,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop Name',
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
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
                            const SizedBox(
                              width: 8,
                            ),
                            Text('376 Reviews')
                          ],
                        ),
                      ),
                      const Text('\$\$   Barber Shop'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text('Address'),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.7,
                    height: 30,
                    child: TabBar(
                      automaticIndicatorColorAdjustment: true,
                      enableFeedback: true,
                      indicatorColor: Colors.black,
                      indicatorWeight: 3,
                      tabs: myTabs,
                      controller: _tabController,
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 0,
                  )
                ],
              ),
              Container(
                width: double.infinity,
                height: height * 2,
                child: TabBarView(controller: _tabController, children: [
                  ShopBookingsPage(),
                  const Center(
                    child: Text('data'),
                  ),
                  const Center(
                    child: Text('data'),
                  ),
                  const Center(
                    child: Text('data'),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
