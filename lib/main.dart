import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lot_recrutation_app/HomePage.dart';
import 'package:lot_recrutation_app/Providers/FlightsProvider.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>HomePageProvider()),
        ChangeNotifierProvider(create: (context)=>FlightsProvider())
      ],
      child: MaterialApp(
        title: 'LOT recruitment app',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.blueGrey[200],
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
      )
    );
  }
}
