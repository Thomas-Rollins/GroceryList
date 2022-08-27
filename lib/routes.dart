import 'package:flutter/material.dart';
import 'package:grocery_list/ui/auth/account_creation_screen.dart';
import 'package:grocery_list/ui/auth/sign_in_screen.dart';
import 'package:grocery_list/ui/list/lists.dart';
import 'package:grocery_list/ui/list/user_items_view.dart';
import 'package:grocery_list/ui/setting/setting_screen.dart';
import 'package:grocery_list/ui/splash/splash_screen.dart';

class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String list_view = '/list_view';
  static const String create_edit_list = '/create_edit_list';
  static const String user_items_view = '/user_items';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    login: (BuildContext context) => const SignInScreen(),
    register: (BuildContext context) => const AccountCreationScreen(),
    home: (BuildContext context) => ListsScreen(),
    setting: (BuildContext context) => const SettingScreen(),
    list_view: (BuildContext context) => ListView(),
    user_items_view: (BuildContext context) => UserItemsView(),

    //temp redirect to lists screen
    create_edit_list: (BuildContext context) => ListView()
  };
}
