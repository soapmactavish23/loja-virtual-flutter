import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';

class CardFront extends StatelessWidget {
  const CardFront({Key? key}) : super(key: key);

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
              children: const [
                CardTextField(
                  title: 'Número',
                  hint: '0000 0000 0000 0000',
                  textInputType: TextInputType.number,
                  bold: true,
                ),
                CardTextField(
                  title: 'Validade',
                  hint: 'XX/XXXX',
                  textInputType: TextInputType.number,
                ),
                CardTextField(
                  title: 'Titular',
                  hint: 'Digite seu nome',
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
