import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HairCutBookingDetailsPage extends StatefulWidget {
  HairCutBookingDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/HairCutBookingDetailsPage';

  @override
  _HairCutBookingDetailsPageState createState() =>
      _HairCutBookingDetailsPageState();
}

class _HairCutBookingDetailsPageState extends State<HairCutBookingDetailsPage> {
  TextStyle paraStyle() {
    return GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 14);
  }

  TextStyle headingStyle() {
    return GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 12, vertical: topPadding + 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                r"""Ray's Barber Shop """,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700, fontSize: 28),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Booking Completed',
                  style: paraStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Dec 27 2021',
                  style: paraStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: double.infinity - 24,
                  height: 37.82,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4.47)),
                  alignment: Alignment.center,
                  child: Text(
                    'Leave A Review',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(235, 87, 87, 1)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: double.infinity - 24,
                  height: 37.82,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(235, 87, 87, 1),
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(4.47)),
                  alignment: Alignment.center,
                  child: Text(
                    'Book Again',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Stylist',
                  style: headingStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 57,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/stylist.png')
                            // MemoryImage(
                            //   Uint8List.fromList(
                            //       _fileBytes.cast<int>().toList()),
                            // ),
                            ),
                      ),
                    ),
                    Text(
                      'Bo WieKnife',
                      style: paraStyle(),
                    )
                  ],
                ),
              ),
              Text(
                'Details',
                style: headingStyle(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32),
                child: Row(
                  children: [
                    Container(
                      width: 115,
                      height: 52,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/scissor.png',
                                        fit: BoxFit.contain),
                                  ),
                                  backgroundColor: Colors.white,
                                  // backgroundImage: AssetImage(
                                  //   'assets/images/scissor.png',
                                  // ),
                                )),
                            Text('Haircut', style: headingStyle())
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 115,
                      height: 52,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/scissor.png',
                                        fit: BoxFit.contain),
                                  ),
                                  backgroundColor: Colors.white,
                                  // backgroundImage: AssetImage(
                                  //   'assets/images/scissor.png',
                                  // ),
                                )),
                            Text('Shave', style: headingStyle())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Receipt',
                style: headingStyle(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0),
                child: Row(
                  children: [
                    Container(
                      height: 57,
                      width: 10,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 0,
                              child: Container(
                                  width: 8,
                                  height: 8,
                                  child: Image.asset(
                                      'assets/images/Ellipse.png'))),
                          Positioned(
                              bottom: 27,
                              child: Container(
                                  width: 8,
                                  height: 8,
                                  child: Image.asset(
                                      'assets/images/Ellipse.png'))),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                  width: 8,
                                  height: 57,
                                  child:
                                      Image.asset('assets/images/line.png'))),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                  width: 8,
                                  height: 8,
                                  child:
                                      Image.asset('assets/images/Ellipse.png')))
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Container(
                      height: 60,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Shampoo',
                                style: paraStyle(),
                              ),
                              SizedBox(width: width - 143),
                              Text('\$5.00')
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Haircut',
                                style: paraStyle(),
                              ),
                              SizedBox(width: width - 137),
                              Text('\$15.00')
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Shave',
                                style: paraStyle(),
                              ),
                              SizedBox(width: width - 121),
                              Text('\$5.00')
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24.0, bottom: 9),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18))),
                    Text('\$20.00',
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Address',
                  style: headingStyle(),
                ),
              ),
              Text(
                '46 Park PI, new York,NY 10036',
                style: paraStyle(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 240,
                  height: 135,
                  color: const Color.fromRGBO(196, 196, 196, 1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 32),
                child: Text(
                  'Phone Number',
                  style: headingStyle(),
                ),
              ),
              Text(
                '(212)593-2121',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color.fromRGBO(235, 87, 87, 1)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
