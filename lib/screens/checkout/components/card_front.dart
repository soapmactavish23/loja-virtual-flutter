import 'package:flutter/material.dart';

class CardFront extends StatelessWidget {
  const CardFront({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 16,
      child: Container(
        height: 200,
        color: const Color(0xFF184B52),
      ),
    );
  }
}
