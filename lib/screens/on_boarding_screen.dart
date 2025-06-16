import 'package:flutter/material.dart';
import 'package:mediscan/screens/user_type_selection_screen.dart';
import 'package:mediscan/widgets/board_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  String buttonText = 'Skip';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          onPageChanged: (index) {
            currentIndex = index;
            if (currentIndex == 2) {
              buttonText = 'Finish';
              setState(() {});
            }
          },
          controller: pageController, // Ensure PageView is controlled
          children: [
            BoardItem(
              title: 'Understand Prescriptions 🩺',
              description:
                  'Quickly scan handwritten medical prescriptions using your camera',
              image: 'assets/onBoarding/on2.png',
            ),

            BoardItem(
              title: 'Find Pharmacies Easily 📍',
              description:
                  'Allow location access so we can show pharmacies close to you .',
              image: 'assets/onBoarding/on1.png',
            ),
            BoardItem(
              title: 'just scan 📷',
              description:
                  'Easily scan printed prescriptions to detect and search for medicines instantly',
              image: 'assets/onBoarding/on3.png',
            ),
          ],
        ),
        Container(
          alignment: Alignment(0, 0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserTypeSelectionScreen(),
                    ),
                  );
                },
              ),
              SmoothPageIndicator(controller: pageController, count: 3),
              currentIndex == 2
                  ? SizedBox()
                  : GestureDetector(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    onTap: () {
                      pageController.nextPage(
                        duration: Duration(seconds: 2),
                        curve: Curves.bounceOut,
                      );
                    },
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
