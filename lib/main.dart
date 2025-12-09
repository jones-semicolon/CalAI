import 'package:flutter/material.dart';
import 'pages/widget_tree.dart';
// import 'routes/app_router.dart';
// import 'routes/app_routes.dart';
// import 'theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
          brightness: Brightness.light,
        ),
      ),
      home: WidgetTree(),
    );
  }
}
