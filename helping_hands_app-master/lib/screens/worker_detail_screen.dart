import 'package:flutter/material.dart';
import 'package:helping_hands_app/constant.dart';

import 'confirm_booking.dart';

class WorkerDetailScreen extends StatelessWidget {
  static const String worker_route =
      '/workerroute'; //remember not to give name same as WorkerScreen it will cause trouble

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    final double _mainScreenHeight = (_mediaQuery.size.height) -
        (_mediaQuery.padding.top + _mediaQuery.padding.bottom + 56);

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final workerName = routeArgs['name'];
    final workerRating = routeArgs['rating'];
    final String workerImageUrl = routeArgs['imageUrl'];
    final String charges = routeArgs['charges'];
    final String address = routeArgs['address'];
    final String contact = routeArgs['contact'];
    final String shopName = routeArgs['shopname'];

    return Scaffold(
      body: Stack(
        children: [
          Container(),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            child: Hero(
              tag: workerName,
              child: Image.network(
                workerImageUrl,
                height: _mainScreenHeight * 0.35,
                width: _mediaQuery.size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: _mediaQuery.padding.top + 10,
            left: 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  workerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: _mainScreenHeight * 0.80,
              width: _mediaQuery.size.width,
              decoration: kloginContainerDecoration.copyWith(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 5, top: 16, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WorkerDetailCard(
                      workerName: workerName,
                      rating: workerRating,
                      charges: charges,
                      address: address,
                      contact: contact,
                      shopName: shopName,
                    ),
                    SizedBox(height: 40),
                    RaisedButton.icon(
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: kdarkBlue,
                      onPressed: () {
                        // var val = await
                        Navigator.of(context).pushNamed(
                          BookingScreen.bookingPageRoute,
                          arguments: {
                            'image': workerImageUrl,
                          },
                        );
                        //if (val != null) Navigator.of(context).pop(val);
                      },
                      icon: Icon(Icons.book_outlined, color: Colors.white),
                      label: Text(
                        'Book Now / Schedule',
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                    SizedBox(height: 20),
                    RaisedButton.icon(
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: kdarkBlue,
                      onPressed: () {},
                      icon: Icon(Icons.phone, color: Colors.white),
                      label: Text(
                        'Call Now',
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkerDetailCard extends StatelessWidget {
  final String workerName;
  final double rating;
  final String charges;
  final String address;
  final String contact;
  final String shopName;
  WorkerDetailCard({
    this.workerName,
    this.rating,
    this.charges,
    this.shopName,
    this.contact,
    this.address,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: kdarkBlue),
                  title: Text(
                    workerName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.location_on, color: kdarkBlue),
                  title: Text(
                    address,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone, color: kdarkBlue),
                  title: Text(
                    contact,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.star, color: kdarkBlue),
                  title: Text(
                    rating.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.shop_outlined, color: kdarkBlue),
                  title: Text(
                    shopName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Text(
                    ' ₹',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kdarkBlue),
                  ), //Icon(Icons.message, color: kdarkBlue),
                  title: Text(
                    charges,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
