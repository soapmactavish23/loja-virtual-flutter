import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:loja_virtual/models/product.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  const ImagesForm({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: product.images,
      builder: (state) {
        return CarouselSlider(
          options: CarouselOptions(
            height: 400.0,
            viewportFraction: 1.0,
          ),
          items: state.value!.map((image) {
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
          }).toList(),
        );
      },
    );
  }
}
