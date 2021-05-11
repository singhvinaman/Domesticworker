import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helping_hands_app/constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../screens/category_screen.dart';
import '../widget/base_ui.dart';

class LoginScreen extends StatefulWidget {
  static const String loginScreen = '/loginscreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isStartRegister = false;

  Future<void> onTapSignInWithGoogle() async {
    setState(() {
      _isStartRegister = true;
    });
    try {
      await signInWithGoogle();
      setState(() {
        _isStartRegister = false;
      });
      Navigator.pushReplacementNamed(context, CategoryScreen.categoryScreen);
    } catch (e) {
      setState(() {
        _isStartRegister = false;
      });
      print(e.message);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  // Future<void> _tryLoginUser(
  //     {String email,
  //     String password,
  //     String username,
  //     bool islogin,
  //     BuildContext ctx}) async {
  //   UserCredential authUser;
  //   try {
  //     if (this.mounted) {
  //       setState(() {
  //         _isStartRegister = true;
  //       });
  //     }
  //     if (islogin) {
  //       authUser = await _auth.signInWithEmailAndPassword(
  //           email: email, password: password);
  //       // authUser.user.providerData[1].providerId;
  //
  //       Navigator.of(context)
  //           .pushReplacementNamed(CategoryScreen.categoryScreen);
  //     } else {
  //       await _auth.createUserWithEmailAndPassword(
  //           email: email, password: password);
  //
  //       Navigator.of(context)
  //           .pushReplacementNamed(CategoryScreen.categoryScreen);
  //     }
  //   } on PlatformException catch (err) {
  //     if (this.mounted) {
  //       setState(() {
  //         _isStartRegister = false;
  //       });
  //     }
  //     String msg = 'Something went wrong please try again later';
  //     if (err.message != null) {
  //       msg = err.message;
  //     }
  //     print(err.message);
  //     Scaffold.of(ctx).showSnackBar(
  //       SnackBar(
  //         content: Text(msg),
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } catch (err) {
  //     if (this.mounted) {
  //       setState(() {
  //         _isStartRegister = false;
  //       });
  //     }
  //     Scaffold.of(ctx).showSnackBar(
  //       SnackBar(
  //         content: Text(err.message),
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ModalProgressHUD(
        inAsyncCall: _isStartRegister,
        child: SafeArea(
          child: BaseUI(
            fontWeight2: FontWeight.w500,
            padding: const EdgeInsets.only(
                left: 18, top: 40), //this is to simplyfy widget tree
            text1: 'Helping',
            text2: 'Hands',
            fontWeight1: FontWeight.w900,
            fontsize1: 50,
            fontsize2: 50,
            height: 70,
            radius: BorderRadius.only(
              topLeft: Radius.circular(40),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
                  textColor: Colors.white,
                  color: kdarkBlue,
                  onPressed: () {},
                  icon: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  label: Text('Sign in using phone'),
                  highlightElevation: 15,
                ),
                SizedBox(height: 20),
                Text(
                  'Or',
                  style:
                      TextStyle(color: kdarkBlue, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                SignInButton(
                  Buttons.Google,
                  onPressed: onTapSignInWithGoogle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 3.5),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Made  with  ❤  in  UDAIPUR.',
                    style: TextStyle(
                      color: kdarkBlue,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            // AuthForm(
            //   tryLoginUser: _tryLoginUser,
            //   googleSignIn: onTapSignInWithGoogle,
            // ),
          ),
        ),
      ),
    );
  }
}
