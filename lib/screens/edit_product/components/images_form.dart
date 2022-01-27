import "package:flutter/material.dart";
import 'package:loja_virtual/models/product.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  const ImagesForm({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: product.images,
      builder: (state) {},
    );
  }
}
