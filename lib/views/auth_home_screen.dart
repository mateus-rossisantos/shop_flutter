import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:shop/views/auth_screen.dart';
import 'package:shop/views/product_overview_screen.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
        }
      },
    );
  }
}
