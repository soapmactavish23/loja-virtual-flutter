import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/product/component/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          product.name,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              viewportFraction: 1.0,
            ),
            items: product.images.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Image.network(url);
                },
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'A partir de ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Text(
                  'R\$ 19,99',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Tamanho',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((s) {
                      return SizeWidget(size: s);
                    }).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
