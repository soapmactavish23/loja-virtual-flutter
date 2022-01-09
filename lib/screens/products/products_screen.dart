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
    searchProducts(ProductManager productManager) async {
      final search = await showDialog<String>(
        context: context,
        builder: (_) => SearchDialog(
          initialText: productManager.search,
        ),
      );
      if (search != null) {
        productManager.search = search;
      }
    }

    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return const Text("Produtos");
              } else {
                return LayoutBuilder(builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () {
                      searchProducts(productManager);
                    },
                    child: Container(
                      width: constraints.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                });
              }
            },
          ),
          centerTitle: true,
          actions: [
            Consumer<ProductManager>(
              builder: (_, productManager, __) {
                if (productManager.search.isEmpty) {
                  return IconButton(
                    onPressed: () async {
                      searchProducts(productManager);
                    },
                    icon: const Icon(Icons.search),
                  );
                } else {
                  return IconButton(
                    onPressed: () async {
                      productManager.search = '';
                    },
                    icon: const Icon(Icons.close),
                  );
                }
              },
            ),
          ],
        ),
        body: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            final filteredProducts = productManager.filteredProducts;
            return ListView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: filteredProducts.length,
                itemBuilder: (_, index) {
                  return ProductListTile(filteredProducts[index]);
                });
          },
        ));
  }
}
