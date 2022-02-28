import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/models/admin_user_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/address/address_screen.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUserManager>(
          create: (_) => AdminUserManager(),
          lazy: false,
          update: (_, userManager, adminUserManager) =>
              adminUserManager!..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: 'Loja da SH',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff155079),
          scaffoldBackgroundColor: const Color(0xff155079),
          accentColor: Color.fromARGB(255, 4, 125, 141),
          appBarTheme:
              const AppBarTheme(elevation: 0, color: Color(0xff155079)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/base",
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/login":
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case "/signup":
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case "/product":
              return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  product: settings.arguments as Product,
                ),
              );
            case "/cart":
              return MaterialPageRoute(
                builder: (_) => const CartScreen(),
              );
            case "/address":
              return MaterialPageRoute(
                builder: (_) => const AddressScreen(),
              );
            case "/edit_product":
              return MaterialPageRoute(
                builder: (_) =>
                    EditProductScreen(settings.arguments as Product),
              );
            case "/select_product":
              return MaterialPageRoute(
                builder: (_) => const SelectProductScreen(),
              );
            case "/checkout":
              return MaterialPageRoute(
                builder: (_) => const CheckoutScreen(),
              );
            case "/base":
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen());
          }
        },
        home: BaseScreen(),
      ),
    );
  }
}
