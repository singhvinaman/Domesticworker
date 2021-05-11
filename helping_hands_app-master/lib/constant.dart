import 'package:flutter/material.dart';

const Color kdarkBlue = Color(0xFF006BFF);

const TextStyle kloginText = TextStyle(
  color: Colors.white,
  fontSize: 50,
  fontWeight: FontWeight.w400,
);

const BoxDecoration kloginContainerDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(10, -6),
      spreadRadius: 2,
      blurRadius: 20,
    ),
    BoxShadow(
      color: Colors.black12,
      offset: Offset(-20, -6),
      spreadRadius: 0,
      blurRadius: 40,
    )
  ],
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40),
  ),
);

const InputDecoration klogininput = InputDecoration(
  prefixIcon: Icon(
    Icons.email_outlined,
    color: kdarkBlue,
  ),
  //hintText: 'E-mail address',
  labelText: 'E-mail',
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
);
