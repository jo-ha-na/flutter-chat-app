import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("À propos de CyberPsy")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CyberPsy", style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 16),
            Text(
              "CyberPsy est une plateforme innovante développée dans le but de sensibiliser les utilisateurs aux risques liés à la cybersécurité psychologique. Grâce à des simulations, des questionnaires interactifs et un système de communication en temps réel, CyberPsy permet aux utilisateurs de mieux comprendre les techniques de manipulation utilisées par les cybercriminels.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text("Créateurs", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(
              "Ce projet a été conçu par une équipe passionnée de développeurs, designers et spécialistes de la cybersécurité.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text("Jeu Android", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(
              "Notre jeu Android complémentaire permet de tester vos réflexes face à des attaques psychologiques en situation de simulation gamifiée. Téléchargez-le depuis le Play Store pour prolonger votre apprentissage !",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
