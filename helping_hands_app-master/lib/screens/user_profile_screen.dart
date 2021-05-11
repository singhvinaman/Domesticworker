import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hands_app/constant.dart';
import 'package:helping_hands_app/widget/base_ui.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserProfile extends StatefulWidget {
  static const String userProfileScreen = '/userProfile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  String _name = '';
  String _address = '';
  String _phoneNumber = '';
  bool _showProgressIndicator = false;

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

  void getUserData() async {
    final String userUID = _auth.currentUser.uid;
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

      _nameController.text = _name;
      _addressController.text = _address;
      _contactController.text = _phoneNumber;
    }
  }

  void _trySavingForm() async {
    FocusScope.of(context).unfocus();

    bool _isValid = _formKey.currentState.validate();

    if (_isValid) {
      _formKey.currentState.save();
      final String userUID = _auth.currentUser.uid;
      setState(() {
        _showProgressIndicator = true;
      });
      await _firestore.collection('users').doc(userUID).set({
        'name': _name,
        'address': _address,
        'contact': _phoneNumber,
      });
      setState(() {
        _showProgressIndicator = false;
      });
    } else {
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kdarkBlue,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: ModalProgressHUD(
        inAsyncCall: _showProgressIndicator,
        child: SafeArea(
          child: BaseUI(
            text1: userName,
            text2: _auth.currentUser.email,
            fontsize1: 45,
            fontsize2: 20,
            fontWeight2: FontWeight.bold,
            height: 70,
            padding: const EdgeInsets.only(left: 18, top: 20),
            radius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 40, bottom: 10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: kdarkBlue),
                          border: OutlineInputBorder(),
                          labelText: 'Your Name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter valid name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.home_filled, color: kdarkBlue),
                          border: OutlineInputBorder(),
                          labelText: 'Your Address',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter valid Address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _address = value;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _contactController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: kdarkBlue),
                          border: OutlineInputBorder(),
                          labelText: 'Your Contact No.',
                        ),
                        validator: (value) {
                          if (value.length != 10) {
                            return 'Please enter valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _phoneNumber = value;
                        },
                      ),
                      SizedBox(height: 70),
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
                          'Edit Profile',
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
      ),
    );
  }
}
