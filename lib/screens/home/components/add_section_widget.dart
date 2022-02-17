import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/src/provider.dart';

class AddSectionWidget extends StatelessWidget {
  final HomeManager homeManager;

  const AddSectionWidget({Key? key, required this.homeManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              homeManager.addSection(Section(type: "List", items: []));
            },
            child: const Text(
              "Adicionar Lista",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered', items: []));
            },
            child: const Text(
              "Adicionar Grade",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
