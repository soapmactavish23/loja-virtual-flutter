import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  const ImagesForm({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) {
        if (images!.isEmpty) {
          return 'Insira ao menos uma imagem';
        } else {
          return null;
        }
      },
      builder: (state) {
        void onImageSelected(File file) {
          state.value!.add(file);
          state.didChange(state.value);
          Navigator.pop(context);
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  viewportFraction: 1.0,
                  autoPlay: false,
                  aspectRatio: 1,
                ),
                items: state.value!.map<Widget>(
                  (image) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (image is String)
                          Image.network(
                            image,
                            fit: BoxFit.cover,
                          )
                        else
                          Image.file(
                            image as File,
                            fit: BoxFit.cover,
                          ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            color: Colors.red,
                            onPressed: () {
                              state.value!.remove(image);
                              state.didChange(state.value);
                            },
                          ),
                        )
                      ],
                    );
                  },
                ).toList()
                  ..add(
                    SizedBox(
                      width: 400,
                      child: Material(
                        color: Colors.grey[100],
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          color: Theme.of(context).primaryColor,
                          iconSize: 50,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (_) => ImageSourceSheet(
                                      onImageSelected: onImageSelected,
                                    ));
                          },
                        ),
                      ),
                    ),
                  ),
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
