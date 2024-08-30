import 'package:flutter/material.dart';
import 'package:gemini_ai/Home.dart';
import 'package:gemini_ai/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ThemeProvider()..initTheme(),
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
         themeMode: value.isToggle?ThemeMode.dark:ThemeMode.light,
         darkTheme: value.isToggle?value.darkTheme:value.lightTheme,
            home: ChatScreen(),
          );
        },

      ),
    );
  }
}
