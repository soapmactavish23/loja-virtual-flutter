import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {
  CardFront({Key? key}) : super(key: key);

  final dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 16,
      child: Container(
        height: 200,
        color: const Color(0xFF184B52),
        padding: const EdgeInsets.all(24),
        child: Row(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CardTextField(
                  title: 'Número',
                  hint: '0000 0000 0000 0000',
                  textInputType: TextInputType.number,
                  bold: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CartaoBancarioInputFormatter(),
                  ],
                ),
                CardTextField(
                  title: 'Validade',
                  hint: 'XX/XXXX',
                  textInputType: TextInputType.number,
                  inputFormatters: [dateFormatter],
                ),
                CardTextField(
                  title: 'Titular',
                  hint: 'Digite seu nome',
                  inputFormatters: [],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
