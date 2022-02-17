import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/edit_product/components/image_source_sheet.dart';

class AddTileWidget extends StatelessWidget {
  const AddTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onImageSelected(File file) {}

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
