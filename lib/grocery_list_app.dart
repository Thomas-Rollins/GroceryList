import 'package:flutter/material.dart';
import 'package:grocery_list/app_localizations.dart';
import 'package:grocery_list/auth_widget_builder.dart';
import 'package:grocery_list/constants/app_themes.dart';
import 'package:grocery_list/flavour.dart';
import 'package:grocery_list/models/user_model.dart';
import 'package:grocery_list/providers/auth_provider.dart';
import 'package:grocery_list/providers/language_provider.dart';
import 'package:grocery_list/providers/theme_provider.dart';
import 'package:grocery_list/routes.dart';
import 'package:grocery_list/services/firestore_database.dart';
import 'package:grocery_list/ui/auth/sign_in_screen.dart';
import 'package:grocery_list/ui/home/home.dart';
import 'package:provider/provider.dart';


class GroceryListApp extends StatelessWidget {
  const GroceryListApp({required Key key, required this.databaseBuilder})
    : super(key: key);

  final FirestoreDatabase Function(BuildContext context, String uid)
  databaseBuilder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        return Consumer<LanguageProvider>(
          builder: (_, languageProviderRef, __) {
        return AuthWidgetBuilder(
          databaseBuilder: databaseBuilder,
          builder: (BuildContext context, AsyncSnapshot<UserModel> userSnapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: true,
              locale: languageProviderRef.appLocale,
              supportedLocales: const [
                Locale('en', 'CA')
              ],
              //These delegates make sure that the localization data for the proper language is loaded
              localizationsDelegates: const [
                //A class which loads the translations from JSON files
                AppLocalizations.delegate,
                // //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                // GlobalMaterialLocalizations.delegate,
                // //Built-in localization for text direction LTR/RTL
                // GlobalWidgetsLocalizations.delegate,
              ],
              //return a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) {
                //check if the current device locale is supported or not
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode ==
                      locale?.languageCode ||
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                //if the locale from the mobile device is not supported yet,
                //user the first one from the list (in our case, that will be English)
                return supportedLocales.first;
              },
              title: Provider.of<Flavour>(context).toString(),
              routes: Routes.routes,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeProviderRef.isDarkModeOn
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: Consumer<AuthProvider>(
                builder: (_, authProviderRef, __) {
                  if (userSnapshot.connectionState == ConnectionState.active) {
                    UserModel user = userSnapshot.data as UserModel;
                    // A null UserModel has a uid of 'null'
                    return user.uid == 'null' ? const SignInScreen() : const HomeScreen();
                  }

                  return const Material(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          },
          key: const Key('AuthWidget'),
        );
      },
    );
  },
  );
}
}