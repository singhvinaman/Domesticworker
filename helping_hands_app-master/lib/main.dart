import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helping_hands_app/screens/login_screen.dart';
import 'package:helping_hands_app/screens/worker_screen.dart';
import 'package:page_transition/page_transition.dart';

import './screens/category_screen.dart';
import './screens/confirm_booking.dart';
import './screens/user_profile_screen.dart';
import './screens/worker_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.white,
        primaryColor: Color(0xFF006BFF),
        fontFamily: 'Montserrat',
      ),
      title: 'Helping Hands',
      home: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapShot) {
          if (userSnapShot.hasData) {
            return CategoryScreen();
          }
          return LoginScreen();
        },
      ),
      // routes: {
      //   LoginScreen.loginScreen: (context) => LoginScreen(),
      //   CategoryScreen.categoryScreen: (context) => CategoryScreen(),
      //   WorkerScreen.workerscreen: (context) => WorkerScreen(),
      //   WorkerDetailScreen.worker_route: (context) => WorkerDetailScreen(),
      //   BookingScreen.bookingPageRoute: (context) => BookingScreen(),
      //   UserDetailScreen.userDetailScreen: (context) => UserDetailScreen(),
      // },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginScreen.loginScreen:
            return PageTransition(
              child: LoginScreen(),
              curve: Curves.linear,
              type: PageTransitionType.topToBottom,
            );
            break;

          case CategoryScreen.categoryScreen:
            return PageTransition(
              child: CategoryScreen(),
              curve: Curves.linear,
              type: PageTransitionType.bottomToTop,
            );
            break;
          case WorkerScreen.workerscreen:
            return PageTransition(
              child: WorkerScreen(),
              curve: Curves.linear,
              // childCurrent: this,  childCurrent is used when we use any 'joined' page transition
              type: PageTransitionType.rightToLeftWithFade,
              settings:
                  settings, //setting argument is used when we are passing Data through NamedRoutes just like in WorkerScreen()
            );
            break;
          case WorkerDetailScreen.worker_route:
            return PageTransition(
              child: WorkerDetailScreen(),
              curve: Curves.linear,
              type: PageTransitionType.rightToLeftWithFade,
              settings:
                  settings, //setting argument is used when we are passing Data through NamedRoutes just like in WorkerScreen()
            );
            break;
          case BookingScreen.bookingPageRoute:
            return PageTransition(
              child: BookingScreen(),
              curve: Curves.linear,
              type: PageTransitionType.rightToLeftWithFade,
              settings:
                  settings, //setting argument is used when we are passing Data through NamedRoutes just like in WorkerScreen()
            );
            break;
          case UserProfile.userProfileScreen:
            return PageTransition(
              child: UserProfile(),
              curve: Curves.linear,
              type: PageTransitionType.rightToLeftWithFade,
              settings:
                  settings, //setting argument is used when we are passing Data through NamedRoutes just like in WorkerScreen()
            );
            break;
          default:
            return null;
        }
      },
    );
  }
}
