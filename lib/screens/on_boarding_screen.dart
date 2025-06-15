// import 'package:flutter/material.dart';
// import 'package:mediscan/widgets/board_item.dart';

// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({super.key});

//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }

// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   PageController pageController = PageController();
//   String buttonText = 'Skip';
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return ScrollingOptions(
//       child: Stack(
//         children: [
//           PageView(
//             onPageChanged: (index) {
//               currentIndex = index;
//               if (currentIndex == 2) {
//                 buttonText = 'Finish';
//                 setState(() {});
//               }
//             },
//             controller: pageController, // Ensure PageView is controlled
//             children: [
//               BoardItem(
//                 title: 'Stay Updated with Match time',
//                 description:
//                     'Get real-time updates on match time all over the world!',
//                 image: 'assets/on_boardings/basket1.png',
//               ),

//               BoardItem(
//                 title: 'All Stats in One Place',
//                 description:
//                     'Track performance, statistics, and key match highlights with ease.',
//                 image: 'assets/on_boardings/basket3.png',
//               ),
//               BoardItem(
//                 title: 'Check Team Lineups',
//                 description:
//                     'Explore team rosters and starting lineups for every match',
//                 image: 'assets/on_boardings/basket2.png',
//               ),
//             ],
//           ),
//           Container(
//             alignment: Alignment(0, 0.8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   child: Text(
//                     buttonText,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                       decoration: TextDecoration.none,
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => MatchesScreen()),
//                     );
//                   },
//                 ),
//                 SmoothPageIndicator(controller: pageController, count: 3),
//                 currentIndex == 2
//                     ? SizedBox()
//                     : GestureDetector(
//                       child: Text(
//                         'Next',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                           decoration: TextDecoration.none,
//                         ),
//                       ),
//                       onTap: () {
//                         pageController.nextPage(
//                           duration: Duration(seconds: 2),
//                           curve: Curves.bounceOut,
//                         );
//                       },
//                     ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
