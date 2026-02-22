import 'package:flutter/material.dart';
import '../widgets/health_score_explanation_widget.dart';

class HealthScoreExplanationScreen extends StatelessWidget {
  const HealthScoreExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(7),
          child: Material(
            color: colors.secondary,
            shape: const CircleBorder(),
            child: IconButton(
              iconSize: 25,
              icon: Icon(Icons.arrow_back, color: colors.onPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'How does it work?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.onPrimary,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: HealthScoreExplanationWidget(),
        ),
      ),
    );
  }
}
