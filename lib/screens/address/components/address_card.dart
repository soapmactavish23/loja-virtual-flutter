import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/address/components/address_input_field.dart';
import 'package:loja_virtual/screens/address/components/cep_input_field.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Consumer<CartManager>(builder: (_, cartManager, __) {
            final address = cartManager.address ?? Address();
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereço de Entrega',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  CepInputField(),
                  if (address.zipCode != null)
                    AddressInputField(address: address),
                ],
              ),
            );
          })),
    );
  }
}
