import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:loja_virtual/models/address.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {
  final Address address;
  ExportAddressDialog({
    Key? key,
    required this.address,
  }) : super(key: key);

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${address.street}, ${address.number} ${address.complement}\n${address.district}\n${address.city}/${address.state}\n${address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              final image = await screenshotController.capture();
              final directory = await getApplicationDocumentsDirectory();
              final file = await File('${directory.path}/image.png').create();
              await file.writeAsBytes(image!);
              await GallerySaver.saveImage(file.path);
              Navigator.pop(context);
            } catch (e) {
              debugPrint(e.toString());
            }
          },
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
