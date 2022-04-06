import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/screens/singin_and_signup_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart';
import 'screens/reset_password_screen.dart';

void main() {
  setPathUrlStrategy();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantry Recipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      onGenerateRoute: (settings){
        var paths = settings.name!.split('?');
        var path = paths[0];
        var queryParameters = Uri.splitQueryString(paths[1]);

        if (path == ResetPasswordScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) {
              return ResetPasswordScreen(
                accessToken: queryParameters['access-token'],
                client: queryParameters['client'],
                clientId: queryParameters['client_id'],
                uid: queryParameters['uid'],
              );
            },
          );
        }
      },
      home: SignInAndSingUpScreen(),
    );
  }
}
