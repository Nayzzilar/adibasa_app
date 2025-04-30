import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adibasa_app/screens/onboarding/second_page.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SecondPage()),
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 300.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/logo.png', width: 100, height: 150),
              SizedBox(height: 5),
              Text(
                'AdiBasa',
                style: GoogleFonts.ptSerif(
                textStyle: TextStyle(
                  fontSize: 45,
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
