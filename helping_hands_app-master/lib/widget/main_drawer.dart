import 'package:flutter/material.dart';
import 'package:helping_hands_app/constant.dart';

import '../screens/user_profile_screen.dart';

class MainDrawer extends StatelessWidget {
  final String userName;
  final String imageUrl;
  final void Function(BuildContext context) logoutFun;
  final BuildContext ctx;

  MainDrawer({this.imageUrl, this.userName, this.logoutFun, this.ctx});

  Widget buildListTile(String text, IconData icon, Function onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: kdarkBlue),
      title: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 70),
            color: kdarkBlue,
            width: double.infinity,
            height: 200,
            child: SafeArea(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: imageUrl != ''
                      ? FadeInImage(
                          height: 58,
                          width: 56,
                          fit: BoxFit.fill,
                          placeholder:
                              AssetImage('assets/images/user_avatar.PNG'),
                          image: NetworkImage(imageUrl),
                        )
                      : AssetImage('assets/images/user_avatar.PNG'),
                ),

                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   radius: 28,
                //   backgroundImage: imageUrl != ''
                //       ? FadeInImage(
                //           placeholder: AssetImage('assets/images/logo.jpg'),
                //           image: NetworkImage(imageUrl),
                //         )
                //       : AssetImage('assets/images/ee.PNG'),
                // ),
                title: Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                subtitle: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          buildListTile(
            'Your Profile',
            Icons.account_circle,
            () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserProfile.userProfileScreen,
                  arguments: userName);
            },
          ),
          SizedBox(height: 10),
          buildListTile(
            'User Privacy Policy',
            Icons.privacy_tip,
            () {},
          ),
          SizedBox(height: 10),
          buildListTile(
            'About Us',
            Icons.assignment,
            () {},
          ),
          SizedBox(height: 10),
          buildListTile(
            'Logout',
            Icons.logout,
            () {
              Navigator.of(context).pop();
              logoutFun(ctx);
            },
          ),
        ],
      ),
    );
  }
}
