import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({Key? key, required this.onImageSelected}) : super(key: key);

  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () async {
              final XFile? file =
                  await picker.pickImage(source: ImageSource.camera);
              onImageSelected(File(file!.path));
            },
            child: const Text("Câmera"),
          ),
          TextButton(
            onPressed: () async {
              final XFile? file =
                  await picker.pickImage(source: ImageSource.gallery);
              onImageSelected(File(file!.path));
            },
            child: const Text("Galeria"),
          ),
        ],
      ),
    );
  }
}
