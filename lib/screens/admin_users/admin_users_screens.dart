import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/admin_user_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:provider/provider.dart';

class AdminUserScreen extends StatelessWidget {
  const AdminUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUserManager>(builder: (_, adminUserManager, __) {
        List<UserModel> users = adminUserManager.users;

        return AlphabetListScrollView(
          itemBuilder: (_, i) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                users[i].name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                users[i].email,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                context.read<AdminOrdersManager>().setUserFilter(users[i]);
                context.read<PageManager>().setPage(5);
              },
            );
          },
          highlightTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          keyboardUsage: true,
          indexedHeight: (index) => 80,
          strList: adminUserManager.names,
          showPreview: true,
        );
      }),
    );
  }
}
