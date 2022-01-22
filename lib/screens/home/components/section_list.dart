import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/screens/home/components/item_tile.dart';
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
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(
                width: 4,
              ),
              itemCount: section.items.length,
              itemBuilder: (_, index) {
                return ItemTile(item: section.items[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
