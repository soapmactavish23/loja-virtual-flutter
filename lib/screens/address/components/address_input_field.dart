import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:validadores/validadores.dart';

class AddressInputField extends StatelessWidget {
  final Address address;

  const AddressInputField({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (address.zipCode != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: (value) {
              return Validador()
                  .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                  .validar(value);
            },
            onSaved: (value) => address.street = value,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: address.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    hintText: '123',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                        .validar(value);
                  },
                  onSaved: (t) => address.number = t,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (t) => address.complement = t,
                ),
              ),
            ],
          ),
          TextFormField(
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Guanabara',
            ),
            onSaved: (t) => address.district = t,
            validator: (value) {
              return Validador()
                  .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                  .validar(value);
            },
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Belém',
                  ),
                  validator: (value) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                        .validar(value);
                  },
                  onSaved: (t) => address.city = t,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Estado',
                    hintText: 'Pará',
                  ),
                  validator: (value) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                        .validar(value);
                  },
                  onSaved: (t) => address.state = t,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            child: const Text('Calcular Frete'),
            onPressed: () {
              if (Form.of(context)!.validate()) {
                Form.of(context)!.save();
                context.read<CartManager>().setAddress(address);
              }
            },
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
