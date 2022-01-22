import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/screens/home/components/item_tile.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;

  const SectionStaggered({Key? key, required this.section}) : super(key: key);

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
          StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: section.items.map<Widget>((item) {
              return ItemTile(
                item: item,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
