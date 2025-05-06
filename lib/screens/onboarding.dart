import 'package:adibasa_app/navigation/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> content = [
    {
      "title": "Pembelajaran berbasis Gamifikasi",
      "desc":
          "Konsep gamifikasi untuk membuat proses belajar terasa lebih menyenangkan dan interaktif.",
      "image": "assets/images/badak_ngegame.png",
    },
    {
      "title": "Kamus Interaktif",
      "desc": "Cari dan pelajari kosakata dalam Bahasa Jawa.",
      "image": "assets/images/badak_berpendidikan_tinggi.png",
    },
    {
      "title": "Sistem Leveling",
      "desc":
          "Cara untuk mengukur dan memotivasi perkembangan pengguna dalam proses belajar.",
      "image": "assets/images/badak_dapet_bintang.png",
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _markOnboardingCompleted() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    prefs.setBool('onboarding_complete', true);
  }

  void _nextPage() {
    if (currentPage < content.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _markOnboardingCompleted();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavbar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            alignment: Alignment.center,
            child: Text(
              "AdiBasa",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => currentPage = index),
              itemCount: content.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 50,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        content[index]['image']!,
                        height: 345.5,
                        width: 258.5,
                      ),
                      Text(
                        content[index]['title']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        content[index]['desc']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              content.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 35 : 13,
                height: 13,
                decoration: BoxDecoration(
                  color:
                      currentPage == index
                          ? CustomColors.buttonColor
                          : CustomColors.slideOnboarding,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child:
                currentPage == content.length - 1
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 2.0,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            minimumSize: Size(330, 48),
                            backgroundColor: CustomColors.borderButton,
                            foregroundColor: Colors.white,
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
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _controller.animateToPage(
                              content.length - 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: Text(
                            "Lewati",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.buttonColor,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                // ← tambahkan di sini
                                color: CustomColors.buttonColor,
                                width:
                                    2.0, // ketebalan border, bisa disesuaikan
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            backgroundColor:
                                CustomColors.borderButton, // jika ingin latar
                            foregroundColor: Colors.white, // warna ikon
                          ),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
