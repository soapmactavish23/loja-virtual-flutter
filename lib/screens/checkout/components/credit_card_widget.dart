import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/components/card_back.dart';
import 'package:loja_virtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatelessWidget {
  CreditCardWidget({Key? key}) : super(key: key);

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

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
            ),
            back: CardBack(
              cvvFocus: cvvFocus,
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
