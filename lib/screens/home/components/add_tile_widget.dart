import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:loja_virtual/screens/edit_product/components/image_source_sheet.dart';

class AddTileWidget extends StatelessWidget {

  final Section section;

  const AddTileWidget({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file, product: ""));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) =>
                  ImageSourceSheet(onImageSelected: onImageSelected));
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
