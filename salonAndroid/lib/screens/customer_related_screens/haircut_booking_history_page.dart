import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salon/screens/customer_related_screens/hair_cut_booking_details_page.dart';

class BookingHistoryPage extends StatefulWidget {
  BookingHistoryPage({Key? key}) : super(key: key);

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  TextStyle paraStyle() {
    return GoogleFonts.roboto(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: const Color.fromRGBO(79, 79, 79, 1));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'History',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700, fontSize: 28),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(HairCutBookingDetailsPage.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: width - 24,
                      height: 199,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: const Color.fromRGBO(196, 196, 196, 1)),
                      child: Stack(
                        children: [
                          Positioned(
                              bottom: 0,
                              child: Container(
                                color: Colors.white,
                                width: width - 24,
                                height: 105,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r"""Ray Barber's Shop """,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          'Booking Completed',
                                          style: paraStyle(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          'Dec 27, 2021',
                                          style: paraStyle(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Not Yet Rated',
                                              style: paraStyle(),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            RatingBar.builder(
                                              itemSize: 15,
                                              initialRating: 5,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Color.fromRGBO(
                                                    79, 79, 79, 1),
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
