import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custom_icon_buttom.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:validadores/Validador.dart';

class CepInputField extends StatelessWidget {
  final Address address;
  CepInputField({Key? key, required this.address}) : super(key: key);

  TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    if (address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: 'XX.XXX-XXX',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            validator: (value) {
              return Validador()
                  .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                  .minLength(10, msg: 'CEP Inválido')
                  .valido(value);
            },
          ),
          ElevatedButton(
            child:
                const Text('Buscar CEP', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (Form.of(context)!.validate()) {
                context.read<CartManager>().getAddress(cepController.text);
              }
            },
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'CEP: ${address.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            ),
          ],
        ),
      );
    }
  }
}
