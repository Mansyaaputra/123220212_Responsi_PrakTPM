import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/createpage.dart';
import 'pages/favoritepage.dart';
import 'models/phone.dart';
import 'pages/editpage.dart';
import 'pages/detailpage.dart';

void main() {
  runApp(const PhoneApp());
}

class PhoneApp extends StatelessWidget {
  const PhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Phone Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromRGBO(27, 127, 226, 1),
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/create': (context) => const CreatePage(),
        '/favorite': (context) => const FavoritePage(),
      },
    
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final phone = settings.arguments as Phone;
          return MaterialPageRoute(builder: (_) => DetailPage(phone: phone));
        } else if (settings.name == '/edit') {
          final phone = settings.arguments as Phone;
          return MaterialPageRoute(builder: (_) => EditPage(phone: phone));
        }
        return null;
      },
    );
  }
}