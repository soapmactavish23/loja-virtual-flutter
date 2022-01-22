import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/screens/home/components/section_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                snap: true,
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja da Software House'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed("/cart"),
                    color: Colors.white,
                    icon: const Icon(Icons.shopping_cart),
                  )
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  final List<Widget> children =
                      homeManager.sections.map<Widget>((section) {
                    switch (section.type) {
                      case 'List':
                        return SectionList(section: section,);
                      case 'Staggered':
                        return Container();
                      default:
                        return Container();
                    }
                  }).toList();
                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
