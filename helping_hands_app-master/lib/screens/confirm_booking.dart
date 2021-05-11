import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hands_app/constant.dart';
import 'package:helping_hands_app/screens/category_screen.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../widget/base_ui.dart';

class BookingScreen extends StatefulWidget {
  static const String bookingPageRoute = '/booking_screen';

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _showProgressIndicator = false;

  DateTime _pickedDate;
  TimeOfDay _pickedTime;
  String _name = '';
  String _address = '';
  String _phoneNumber = '';

  //final _formKey = GlobalKey<FormState>();
  // TextEditingController _nameController = TextEditingController();
  // TextEditingController _addressController = TextEditingController();
  // TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('in init');
    _showProgressIndicator = true;
    if (this.mounted) {
      setState(() {
        getUserData();
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _contactController.dispose();
  //   _addressController.dispose();
  //   _nameController.dispose();
  // }

  void getUserData() async {
    final String userUID = _auth.currentUser.uid;
    // final QuerySnapshot _collectionSnap =
    //     await _firestore.collection('users').get();
    // print('USer Email : $userEmail');
    // var val = _collectionSnap.docs.contains(userEmail);
    // print('Value of val : $val');
    // if (val) {
    //   print('in val if');
    final DocumentSnapshot _docSnap =
        await _firestore.collection('users').doc(userUID).get();
    print('_docSnap : $_docSnap');
    print('Data in User Doc : ${_docSnap.data()}');
    setState(() {
      _showProgressIndicator = false;
    });
    if (_docSnap.data() != null) {
      _name = _docSnap.data()['name'];
      _address = _docSnap.data()['address'];
      _phoneNumber = _docSnap.data()['contact'];

      // _nameController.text = _name;
      // _addressController.text = _address;
      // _contactController.text = _phoneNumber;
    }
    // }
  }

  void _trySavingForm() async {
    if (_pickedDate == null || _pickedTime == null) {
      String _msg;
      if (_pickedDate == null && _pickedTime == null)
        _msg = 'Please Choose Date and Time';
      else if (_pickedTime == null)
        _msg = 'Please Choose a Time';
      else if (_pickedDate == null) _msg = 'Please Choose a Date';
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(_msg),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              )
            ],
          );
        },
      );
    } else {
      setState(() {
        _showProgressIndicator = true;
      });

      await _tryConfirmBooking();
      setState(() {
        _showProgressIndicator = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: SimpleDialog(
              titlePadding: const EdgeInsets.all(20),
              title: Text('Your Booking is Confirmed'),
              children: [
                SimpleDialogOption(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
          CategoryScreen.categoryScreen, (route) => false);
    }
  }

  Future<void> _tryConfirmBooking() async {
    Duration dummyDelay = Duration(seconds: 2);
    await Future.delayed(dummyDelay);
  }

  Widget buildRow(IconData icon, String detail) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Icon(icon, color: kdarkBlue, size: 25),
          SizedBox(width: 40),
          Expanded(
            child: Container(
              //color: Colors.teal,
              // width: 250,
              child: Text(
                detail,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: ModalProgressHUD(
        inAsyncCall: _showProgressIndicator,
        child: SafeArea(
          child: BaseUI(
            text1: 'Confirm Your',
            text2: 'Booking',
            fontsize1: 40,
            fontsize2: 40,
            fontWeight1: FontWeight.bold,
            fontWeight2: FontWeight.w500,
            padding: const EdgeInsets.only(left: 18),
            height: 30,
            radius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 40, bottom: 10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FittedBox(
                      child: Text(
                        '*To change your details please update your Profile.',
                      ),
                    ),
                    SizedBox(height: 30),
                    buildRow(Icons.person, _name),
                    SizedBox(height: 20),
                    buildRow(Icons.home_filled, _address),
                    SizedBox(height: 20),
                    buildRow(Icons.phone, _phoneNumber),
                    SizedBox(height: 20),
                    Divider(thickness: 1.3),
                    SizedBox(height: 30),
                    ChooseDateOrTime(
                      endText: _pickedDate == null
                          ? 'No Date Choosen'
                          : DateFormat.yMd().format(_pickedDate),
                      iconText: _pickedDate == null
                          ? 'Choose a Date'
                          : 'Edit Choosen Date',
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            Duration(
                              days: 7,
                            ),
                          ),
                        ).then((value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _pickedDate = value;
                          });
                        });
                      },
                    ),
                    ChooseDateOrTime(
                      iconText: _pickedTime == null
                          ? 'Choose a Time'
                          : 'Edit Choosen Time',
                      endText: _pickedTime == null
                          ? 'No time Choosen'
                          : _pickedTime.format(context).toString(),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _pickedTime = value;
                          });
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    RaisedButton(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: _trySavingForm,
                      color: kdarkBlue,
                      textColor: Colors.white,
                      child: Text(
                        'Confirm Booking',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseDateOrTime extends StatelessWidget {
  final String iconText;
  final String endText;
  final Function onTap;

  ChooseDateOrTime({
    this.endText,
    this.iconText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          onPressed: onTap,
          child: Text(
            iconText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: kdarkBlue,
            ),
          ),
        ),
        Text(
          endText,
          style: TextStyle(
            fontSize: 17,
            color: kdarkBlue,
          ),
        ),
      ],
    );
  }
}

// TextFormField(
// controller: _nameController,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.person, color: kdarkBlue),
// border: OutlineInputBorder(),
// labelText: 'Your Name',
// ),
// validator: (value) {
// if (value.isEmpty) {
// return 'Please enter valid name';
// }
// return null;
// },
// onSaved: (value) {
// _name = value;
// },
// ),

// TextFormField(
// controller: _addressController,
// maxLines: 4,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.home_filled, color: kdarkBlue),
// border: OutlineInputBorder(),
// labelText: 'Your Address',
// ),
// validator: (value) {
// if (value.isEmpty) {
// return 'Please enter valid Address';
// }
// return null;
// },
// onSaved: (value) {
// _address = value;
// },
// ),

// TextFormField(
// controller: _contactController,
// keyboardType: TextInputType.number,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.phone, color: kdarkBlue),
// border: OutlineInputBorder(),
// labelText: 'Your Contact No.',
// ),
// validator: (value) {
// if (value.length != 10) {
// return 'Please enter valid number';
// }
// return null;
// },
// onSaved: (value) {
// _phoneNumber = value;
// },
// ),

// Puarana Vala _trySavingForm

// void _trySavingForm() async {
//   FocusScope.of(context).unfocus();
//
//   bool _isValid = _formKey.currentState.validate();
//
//   if (_isValid) {
//   if (_pickedDate == null || _pickedTime == null) {
//     String _msg;
//     if (_pickedDate == null && _pickedTime == null)
//       _msg = 'Please Choose Date and Time';
//     else if (_pickedTime == null)
//       _msg = 'Please Choose a Time';
//     else if (_pickedDate == null) _msg = 'Please Choose a Date';
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: Text(_msg),
//           actions: [
//             FlatButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Ok'),
//             )
//           ],
//         );
//       },
//     );
//   } else {
//     // _formKey.currentState.save();
//     // final String userUID = _auth.currentUser.uid;
//     setState(() {
//       _showProgressIndicator = true;
//     });
//     final DocumentSnapshot _docSnap =
//         await _firestore.collection('users').doc(userUID).get();
//     if (_docSnap.data() == null) {
//       print('in set data');
//       await _firestore.collection('users').doc(userUID).set({
//         'name': _name,
//         'address': _address,
//         'contact': _phoneNumber,
//       });
//     }
//     await _tryConfirmBooking();
//     setState(() {
//       _showProgressIndicator = false;
//     });
//     await showDialog(
//       context: context,
//       builder: (ctx) {
//         return GestureDetector(
//           onTap: () {},
//           behavior: HitTestBehavior.opaque,
//           child: SimpleDialog(
//             titlePadding: const EdgeInsets.all(20),
//             title: Text('Your Booking is Confirmed'),
//             children: [
//               SimpleDialogOption(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//     Navigator.of(context).pushNamedAndRemoveUntil(
//         CategoryScreen.categoryScreen, (route) => false);
//   }
//   }
//   else {
//     return;
//   }
// }
