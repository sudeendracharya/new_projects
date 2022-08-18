import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopBookingsPage extends StatefulWidget {
  ShopBookingsPage({Key? key}) : super(key: key);

  @override
  _ShopBookingsPageState createState() => _ShopBookingsPageState();
}

class _ShopBookingsPageState extends State<ShopBookingsPage> {
  List styles = ['Haircut', 'Coloring', 'Shampoo'];
  ScrollController controller = ScrollController();

  TextStyle headingStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Available',
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 32,
                  width: 67,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(235, 87, 87, 1)),
                  child: Text(
                    '6:00 PM',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  height: 32,
                  width: 67,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(235, 87, 87, 1)),
                  child: Text(
                    '6:30 PM',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  height: 32,
                  width: 67,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(235, 87, 87, 1)),
                  child: Text(
                    '7:00 PM',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  height: 32,
                  width: 67,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(235, 87, 87, 1)),
                  child: Text(
                    '7:30 PM',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  height: 32,
                  width: 67,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(86, 204, 242, 1)),
                  child: Text(
                    'Set Alert',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: double.infinity - 24,
              height: 37.82,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.47)),
              alignment: Alignment.center,
              child: Text(
                'Find Future Availability',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(235, 87, 87, 1)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 58.0),
            child: Text(
              'Offerings',
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Popular Items',
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 21.0),
            child: Divider(
              color: Color.fromRGBO(189, 189, 189, 1),
              thickness: 1,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: styles.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: const Color.fromRGBO(196, 196, 196, 1)),
                        alignment: Alignment.center,
                        child: const Text(
                          'Image',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(styles[index]),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Divider(
                      color: Color.fromRGBO(189, 189, 189, 1),
                      thickness: 1,
                    ),
                  )
                ],
              );
            },
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
                'See All Offerings',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(235, 87, 87, 1)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 58.0),
            child: Text(
              'Reviews',
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Overall Ratings',
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '4.8',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700, fontSize: 32),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RatingBar.builder(
                        itemSize: 20,
                        initialRating: 5,
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
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text('5'),
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          width: 127,
                          height: 4,
                          decoration: BoxDecoration(border: Border.all()),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('4'),
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          width: 127,
                          height: 4,
                          decoration: BoxDecoration(border: Border.all()),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('3'),
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          width: 127,
                          height: 4,
                          decoration: BoxDecoration(border: Border.all()),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('2'),
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          width: 127,
                          height: 4,
                          decoration: BoxDecoration(border: Border.all()),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('1'),
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          width: 127,
                          height: 4,
                          decoration: BoxDecoration(border: Border.all()),
                        )
                      ],
                    )
                  ],
                )
              ],
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
                'See All Reviews',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(235, 87, 87, 1)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Text(
              'Details',
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Address',
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              '46 park PI,New York,NY 10036',
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 12),
            child: Container(
              width: double.infinity - 24,
              height: 104,
              color: const Color.fromRGBO(196, 196, 196, 1),
            ),
          ),
          Text(
            'Phone',
            style: headingStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24),
            child: Text(
              '(212)593-2121',
              style: GoogleFonts.roboto(
                  color: Color.fromRGBO(235, 87, 87, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 12),
            ),
          ),
          Text(
            'Price',
            style: headingStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24),
            child: Text(
              '\$20 To \$100',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
          ),
          Text(
            'Shop Type',
            style: headingStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24),
            child: Text(
              'Barber Shop',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
          ),
          Text(
            'Hours Of Operation',
            style: headingStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24),
            child: Text(
              'Mon-Fri 8am - 10pm \nSat-Sun 11am - 10pm',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
