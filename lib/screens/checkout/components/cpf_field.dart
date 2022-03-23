import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:validadores/Validador.dart';

class CpfField extends StatelessWidget {
  const CpfField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CPF',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextFormField(
              initialValue: userManager.user.cpf,
              decoration: const InputDecoration(
                hintText: '000.000.000-00',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              validator: (cpf) {
                return Validador()
                    .add(Validar.CPF, msg: "CPF Inválido")
                    .validar(cpf);
              },
              onSaved: (cpf) {
                userManager.user.setCpf(cpf!);
              },
            )
          ],
        ),
      ),
    );
  }
}
