import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/screens/home/components/add_tile_widget.dart';
import 'package:loja_virtual/screens/home/components/item_tile.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;

  const SectionStaggered({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              section: section,
            ),
            Consumer<Section>(
              builder: (_, section, __) {
                List<Widget> listItems = section.items.map<Widget>((item) {
                  return ItemTile(
                    item: item,
                  );
                }).toList();

                if (homeManager.editing) {
                  listItems.add(AddTileWidget(
                    section: section,
                  ));
                }

                return StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: listItems,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
