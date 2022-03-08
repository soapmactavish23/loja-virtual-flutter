import 'package:flutter/material.dart';

import 'package:loja_virtual/models/address.dart';

class ExportAddressDialog extends StatelessWidget {
  final Address address;
  const ExportAddressDialog({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Text(
        '${address.street}, ${address.number} ${address.complement}\n${address.district}\n${address.city}/${address.state}\n${address.zipCode}',
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
