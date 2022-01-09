import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/products/components/product_list_tile.dart';
import 'package:loja_virtual/screens/products/components/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text("Produtos"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.add)),
            IconButton(onPressed: (){
              showDialog(context: context, builder: (_) => const SearchDialog());
            }, icon: const Icon(Icons.search)),
          ],
        ),
        body: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            return ListView.builder(
              padding: const EdgeInsets.all(4),
                itemCount: productManager.allProducts.length,
                itemBuilder: (_, index) {
                  return ProductListTile(productManager.allProducts[index]);
                });
          },
        ));
  }
}
