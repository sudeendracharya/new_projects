import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/barber_details.dart';
import 'package:salon/screens/customer_related_screens/shop_details_page.dart';

import 'barber_shop.dart';

class FavoriteBarberShop extends StatefulWidget {
  FavoriteBarberShop({
    Key? key,
    required this.businessName,
    required this.description,
    required this.imagePath,
    required this.index,
    required this.favorite,
    required this.update,
    this.id,
    this.token,
  }) : super(key: key);
  final String businessName;
  final String description;
  final List imagePath;
  final int index;
  var token;
  var id;
  final bool favorite;
  final ValueChanged<int> update;
  @override
  _FavoriteBarberShopState createState() => _FavoriteBarberShopState();
}

class _FavoriteBarberShopState extends State<FavoriteBarberShop> {
  void deleteFavorite(var id) {
    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        widget.update(200);
        var token = Provider.of<ApiCalls>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .deleteFavorite(id, token)
            .then((value) {
          if (value == 200 || value == 201 || value == 204) {
            widget.update(100);
          } else {
            Scaffold.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unable to Delete shop from Favorites',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
          // barberList = value;
          // print(barberList.isEmpty);

          // reRun();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GestureDetector(
        onTap: () {
          // BarberDetails.id = widget.id;
          // Navigator.of(context).pushNamed(
          //   BarberShopDetails.routeName,
          //   arguments: {
          //     'index': widget.index,
          //     'token': widget.token,
          //     'image': widget.imagePath
          //   },
          // );
          Navigator.of(context).pushNamed(ShopDetailsPage.routeName);
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 122,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 230,
                    height: 70,
                    child: _buildTitleAndSubTitle(context),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 12, top: 12),
                child: Divider(
                  color: Color.fromRGBO(189, 189, 189, 1),
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildTitleAndSubTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.businessName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: const [
              Text('\$\$ Barber Shop'),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.star,
                size: 15,
              ),
              Text('4.8 (379)'),
            ],
          ),
        ),
        // Row(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(top: 20),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           border: Border.all(),
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         height: 40,
        //         width: MediaQuery.of(context).size.width / 7.5,
        //         child: TextButton(

        //             // style: ElevatedButton.styleFrom(
        //             //     primary: Colors.white, side: BorderSide(width: 2)),
        //             onPressed: () {
        //               deleteFavorite(widget.id);
        //             },
        //             child: const FittedBox(
        //               fit: BoxFit.contain,
        //               child: Text(
        //                 'Remove',
        //                 style: TextStyle(color: Colors.black),
        //               ),
        //             )),
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 20),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           border: Border.all(),
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         height: 40,
        //         width: MediaQuery.of(context).size.width / 7.5,
        //         child: TextButton(
        //             // style: ElevatedButton.styleFrom(
        //             //     primary: Colors.white, side: BorderSide(width: 2)),
        //             onPressed: () {
        //               BarberDetails.id = widget.id;
        //               Navigator.of(context).pushNamed(
        //                 BarberShopDetails.routeName,
        //                 arguments: {
        //                   'index': widget.index,
        //                   'token': widget.token,
        //                   'image': widget.imagePath
        //                 },
        //               );
        //             },
        //             child: const FittedBox(
        //               fit: BoxFit.contain,
        //               child: Text(
        //                 'Book',
        //                 style: TextStyle(color: Colors.black),
        //               ),
        //             )),
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }

  SizedBox _buildImage() {
    return SizedBox(
      width: 82,
      height: 82,
      child:
          //  Container(
          //   color: Colors.blue[200],
          //   child: Text('image'),
          // )
          ClipRRect(
        borderRadius: BorderRadius.circular(1.29),
        child: FittedBox(
          fit: BoxFit.fill,
          clipBehavior: Clip.hardEdge,
          child: widget.imagePath.isEmpty
              ? const Text('NO Image')
              : CachedNetworkImage(
                  //  placeholder: (context, url) => const CircularProgressIndicator(),
                  imageUrl: widget.imagePath.first,
                ),
          //     Image.memory(
          //   Uint8List.fromList(imagePath.cast<int>().toList()),
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }
}
