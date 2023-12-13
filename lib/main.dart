import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/presentation/favourites_page.dart';
import 'package:weather_app/presentation/home_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('favourites');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.firaCodeTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/favourites": (context) => const FavouritesPage()
      },
    );
  }
}
