import 'package:flutter/material.dart';

class BoardItem extends StatelessWidget {
  const BoardItem({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });
  final String title, description, image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(image)),
            SizedBox(height: 30),
            Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
