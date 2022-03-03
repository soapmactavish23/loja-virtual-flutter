import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_product.dart';

class OrderProductTile extends StatelessWidget {
  const OrderProductTile({Key? key, required this.cartProduct})
      : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/product",
          arguments: cartProduct.product!,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(cartProduct.product!.images!.first),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartProduct.product!.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'Tamanho: ${cartProduct.size}',
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'R\$ ${cartProduct.fixedPrice == 0.0 ? cartProduct.unitPrice : cartProduct.fixedPrice}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${cartProduct.quantity}',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
