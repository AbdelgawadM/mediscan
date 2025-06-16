import 'package:flutter/material.dart';

class PharmacyFirstItem extends StatelessWidget {
  const PharmacyFirstItem({
    super.key,
    required this.name,
    required this.image,
    required this.allLenght,
    required this.existLenght,
  });

  final String name, image;
  final int allLenght, existLenght;

  @override
  Widget build(BuildContext context) {
    final bool allMatched = existLenght == allLenght;

    return Container(
      width: 130,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ), // subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            // elevation: 4,
            borderRadius: BorderRadius.circular(12),
            // shadowColor: Colors.black.withOpacity(0.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: allMatched ? Colors.green[100] : Colors.orange[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$existLenght of $allLenght found',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: allMatched ? Colors.green[800] : Colors.orange[800],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
