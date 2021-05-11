import 'package:flutter/material.dart';

import '../screens/worker_screen.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  CategoryItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        WorkerScreen.workerscreen,
        arguments: {
          'title': title,
          'imageUrl': imageUrl,
        },
      ),
      splashColor: Theme.of(context).primaryColor,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(
                tag: 'animation$title',
                child: FadeInImage(
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.fill,
                  image: NetworkImage(imageUrl),
                  placeholder: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.all(5),
                width: 125,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
