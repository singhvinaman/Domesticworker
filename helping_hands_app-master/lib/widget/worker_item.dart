import 'package:flutter/material.dart';
import 'package:helping_hands_app/constant.dart';

import '../screens/worker_detail_screen.dart';

class WorkerItem extends StatelessWidget {
  final String name;
  final double rating;
  final String imageUrl;
  final String charges;
  final String address;
  final String contact;
  final String shopName;
  WorkerItem({
    this.name,
    this.rating,
    this.imageUrl,
    this.charges,
    this.shopName,
    this.address,
    this.contact,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // var val = await
        Navigator.of(context).pushNamed(
          WorkerDetailScreen.worker_route,
          arguments: {
            'name': name,
            'rating': rating,
            'imageUrl': imageUrl,
            'charges': charges,
            'address': address,
            'contact': contact,
            'shopname': shopName
          },
        );
        //if (val != null) Navigator.of(context).pop();
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          subtitle: Text('₹ : $charges',
              style: TextStyle(fontWeight: FontWeight.w600)),
          leading: Hero(
            tag: '$name',
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold, wordSpacing: 2, letterSpacing: 1),
          ),
          trailing: SizedBox(
            width: 55,
            child: Row(
              children: [
                Icon(Icons.star, color: kdarkBlue),
                SizedBox(width: 5),
                Text(rating.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
