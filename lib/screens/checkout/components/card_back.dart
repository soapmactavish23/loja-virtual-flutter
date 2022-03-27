import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {
  const CardBack({Key? key, required this.cvvFocus, required this.creditCard})
      : super(key: key);

  final FocusNode cvvFocus;
  final CreditCard creditCard;

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
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 70,
                      child: Container(
                        color: Colors.grey[500],
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: CardTextField(
                          initialValue: creditCard.securityCode,
                          title: '',
                          hint: '123',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 3,
                          textAlign: TextAlign.end,
                          validator: (cvv) {
                            if (cvv!.length != 3) return 'Inválido';
                            return null;
                          },
                          textInputType: TextInputType.number,
                          focusNode: cvvFocus,
                          onSubmitted: (_) {},
                          onSaved: creditCard.setCVV,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: Container(),
                    ),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
