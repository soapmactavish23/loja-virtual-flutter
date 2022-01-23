import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admin_user_manager.dart';
import 'package:provider/provider.dart';

class AdminUserScreen extends StatelessWidget {
  const AdminUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUserManager>(builder: (_, adminUserManager, __) {
        return AlphabetListScrollView(
          itemBuilder: (_, i) {
            return ListTile(
              title: Text(
                adminUserManager.users[i].name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                adminUserManager.users[i].email,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
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
