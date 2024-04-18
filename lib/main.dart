import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lot_recrutation_app/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOT recruitment app',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.blueGrey[400],
        listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            tileColor: Colors.grey
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color.fromRGBO(217, 217, 217, 100)),
          bodyText2: TextStyle(color: Color.fromRGBO(217, 217, 217, 100)),
          headline1: TextStyle(color: Color.fromRGBO(217, 217, 217, 100)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white)
          ),
        ),
      ),
      supportedLocales: [
        const Locale('en'),
        const Locale('pl', '')
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}