import 'package:flutter/material.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlatButton(
            onPressed: () {},
            child: const Text("Câmera"),
          ),
          FlatButton(
            onPressed: () {},
            child: const Text("Galeria"),
          ),
        ],
      ),
    );
  }
}
