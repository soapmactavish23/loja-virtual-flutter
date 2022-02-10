import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_buttom.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;

  const SizesForm({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormField<List<ItemSize>>(
          initialValue: List.from(product.sizes),
          builder: (state) {
            return Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tamanhos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CustomIconButton(
                      iconData: Icons.add,
                      color: Colors.black,
                      onTap: () {
                        state.value!.add(ItemSize());
                        state.didChange(state.value);
                      },
                    )
                  ],
                ),
                Column(
                  children: state.value!.map((size) {
                    return EditItemSize(
                      key: ObjectKey(size),
                      size: size,
                      onRemove: () {
                        state.value!.remove(size);
                        state.didChange(state.value);
                      },
                      onMoveUp: size != state.value!.first
                          ? () {
                              final index = state.value!.indexOf(size);
                              state.value!.remove(size);
                              state.value!.insert(index - 1, size);
                              state.didChange(state.value);
                            }
                          : null,
                      onMoveDown: size != state.value!.last
                          ? () {
                              final index = state.value!.indexOf(size);
                              state.value!.remove(size);
                              state.value!.insert(index + 1, size);
                              state.didChange(state.value);
                            }
                          : null,
                    );
                  }).toList(),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
