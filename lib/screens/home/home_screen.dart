import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/home/components/add_section_widget.dart';
import 'package:loja_virtual/screens/home/components/section_list.dart';
import 'package:loja_virtual/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              // ignore: deprecated_member_use
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
                  ),
                  Consumer2<UserManager, HomeManager>(
                      builder: (_, userManager, homeManager, __) {
                    if (userManager.adminEnabled && !homeManager.loading) {
                      if (homeManager.editing) {
                        return PopupMenuButton(onSelected: (e) {
                          if (e == "Salvar") {
                            homeManager.saveEditing();
                          } else {
                            homeManager.discartEditing();
                          }
                        }, itemBuilder: (_) {
                          return ['Salvar', 'Descartar'].map((e) {
                            return PopupMenuItem(child: Text(e), value: e);
                          }).toList();
                        });
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: homeManager.enterEditing,
                        );
                      }
                    }
                    return Container();
                  })
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  if (homeManager.loading) {
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }
                  final List<Widget> children =
                      homeManager.sections.map<Widget>((section) {
                    switch (section.type) {
                      case 'List':
                        return SectionList(
                          section: section,
                        );
                      case 'Staggered':
                        return SectionStaggered(
                          section: section,
                        );
                      default:
                        return Container();
                    }
                  }).toList();

                  if (homeManager.editing)
                    // ignore: curly_braces_in_flow_control_structures
                    children.add(AddSectionWidget(
                      homeManager: homeManager,
                    ));

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
