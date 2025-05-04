import 'package:flutter/material.dart';
import 'package:adibasa_app/screens/onboarding/fourth_page.dart';
import 'package:adibasa_app/screens/onboarding/third_page.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "AdiBasa",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/icon.png', height: 345.5, width: 258.5),
              Text(
                'Pembelajaran berbasis Gamifikasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                'konsep gamifikasi untuk membuat proses belajar terasa lebih menyenangkan dan interaktif.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 39,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Color(0xFF7F833A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Color(0xFFAEA6A8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Color(0xFFAEA6A8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FourthPage()),
                        );
                      },
                      child: Text(
                        'Lewati',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Color(0xFF7F833A),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ThirdPage(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              const begin = Offset(1.0, 0.0); // Dari kanan
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              final tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
