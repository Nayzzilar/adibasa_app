import 'package:adibasa_app/navigation/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FourthPage extends StatelessWidget {
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
          // Membungkus Text dengan Center untuk memastikan teks di tengah
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 345.5,
                width: 258.5,
              ),
              Text(
                'Sistem Leveling',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                'cara untuk mengukur dan memotivasi perkembangan pengguna dalam proses belajar.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  SizedBox(width: 8),
                  Container(
                    width: 39,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Color(0xFF7F833A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Ini baru mainAxisAlignment dipakai
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferencesWithCache.create(
                        cacheOptions: SharedPreferencesWithCacheOptions(),
                      );
                      await prefs.setBool('onboarding_complete', true);
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavbar(),
                          ), // replace with your main/home page
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      minimumSize: Size(330, 48),
                    ),
                    child: Text(
                      'Mulai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
