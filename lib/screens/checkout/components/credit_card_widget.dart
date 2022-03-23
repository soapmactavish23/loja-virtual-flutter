import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_back.dart';
import 'package:loja_virtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatelessWidget {
  CreditCardWidget({Key? key, required this.creditCard}) : super(key: key);

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: cardKey,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            flipOnTouch: false,
            front: CardFront(
              nameFocus: nameFocus,
              dateFocus: dateFocus,
              numberFocus: numberFocus,
              finished: () {
                cardKey.currentState!.toggleCard();
                cvvFocus.requestFocus();
              },
              creditCard: creditCard,
            ),
            back: CardBack(
              cvvFocus: cvvFocus,
              creditCard: creditCard,
            ),
          ),
          TextButton(
            onPressed: () {
              cardKey.currentState!.toggleCard();
            },
            child: const Text(
              'Virar cartão',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
