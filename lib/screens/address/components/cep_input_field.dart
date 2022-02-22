import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:validadores/Validador.dart';

class CepInputField extends StatelessWidget {
  TextEditingController cepController = TextEditingController();

  CepInputField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
  }
}
