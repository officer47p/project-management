import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final EdgeInsets padding;
  const CustomAppBar({this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null ? padding : EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
            // color: Color(0xfff5634a),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Center(
          child: Text(
            "Hackathon Master",
            style: TextStyle(
              fontFamily: "RubikMonoOne",
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
