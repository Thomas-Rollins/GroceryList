import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list/firebase_options.dart';
import 'package:grocery_list/flavour.dart';
import 'package:grocery_list/providers/auth_provider.dart';
import 'package:grocery_list/providers/language_provider.dart';
import 'package:grocery_list/providers/theme_provider.dart';
import 'package:grocery_list/services/firestore_database.dart';
import 'package:provider/provider.dart';

import 'grocery_list_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    runApp(
      /*
      * MultiProvider for top services that do not depends on any runtime values
      * such as user uid/email.
       */
      MultiProvider(
        providers: [
          Provider<Flavour>.value(value: Flavour.dev),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider(),
          ),
        ],
        child: GroceryListApp(
          databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
          key: const Key('GroceryListApp'),
        ),
      ),
    );
}
