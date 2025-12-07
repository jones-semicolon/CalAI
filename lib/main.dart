import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';
import 'theme/light_theme.dart';

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
      theme: lightTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
