import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adibasa_app/theme/theme.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> content = [
    {
      "title": "Pembelajaran berbasis Gamifikasi",
      "desc":
          "Konsep gamifikasi untuk membuat proses belajar terasa lebih menyenangkan dan interaktif.",
      "image": "assets/images/icon.png",
    },
    {
      "title": "Kamus Interaktif",
      "desc": "Cari dan pelajari kosakata dalam Bahasa Jawa.",
      "image": "assets/images/icon.png",
    },
    {
      "title": "Sistem Leveling",
      "desc":
          "Cara untuk mengukur dan memotivasi perkembangan pengguna dalam proses belajar.",
      "image": "assets/images/icon.png",
    },
  ];

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboarded = prefs.getBool('onboardingCompleted') ?? false;

    if (isOnboarded) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Dummy()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(
      'onboardingCompleted',
      true,
    ); // Menyimpan status onboarding selesai
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
        MaterialPageRoute(builder: (_) => Dummy()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AdiBasa",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
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
                        ),
                      ),
                      Text(
                        content[index]['desc']!,
                        textAlign: TextAlign.center,
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
              (index) => Container(
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
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            minimumSize: Size(
                              330,
                              48,
                            ), // Lebar dan tinggi tombol
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
    );
  }
}

class Dummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Halaman Utama"), centerTitle: true),
      body: Center(
        child: Text(
          "Selamat Datang di AdiBasa!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
