import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            section: section,
          ),
        ],
      ),
    );
  }
}
