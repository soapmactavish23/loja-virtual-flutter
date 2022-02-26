import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custom_icon_buttom.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:validadores/Validador.dart';

class CepInputField extends StatefulWidget {
  final Address address;
  CepInputField({Key? key, required this.address}) : super(key: key);

  

  @override
  State<CepInputField> createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {

  TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
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
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          ElevatedButton(
            child:
                const Text('Buscar CEP', style: TextStyle(color: Colors.white)),
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context)!.validate()) {
                      try {
                        await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                : null,
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
                'CEP: ${widget.address.zipCode}',
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
