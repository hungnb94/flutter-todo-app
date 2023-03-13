import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/screens/details/details.dart';
import 'package:todo_app/screens/home.dart';

import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Flutter Todo Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: tdBgColor,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(),
        fontFamily: 'Montserrat',
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/details': (context) => const Details(),
      },
    );
  }
}
