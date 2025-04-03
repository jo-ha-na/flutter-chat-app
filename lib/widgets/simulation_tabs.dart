import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/api_service.dart';

class SimulationTabs extends StatelessWidget {
  const SimulationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Simulations"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Profils Attaquants"),
              Tab(text: "Scénarios"),
              Tab(text: "Résultats"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProfilAttaquantTab(),
            ScenarioSimulationTab(),
            ResultatSimulationTab(),
          ],
        ),
      ),
    );
  }
}

class ProfilAttaquantTab extends StatelessWidget {
  const ProfilAttaquantTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getAllProfilAttaquants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erreur chargement profils attaquants"));
        }

        final profils = snapshot.data!;
        return ListView.builder(
          itemCount: profils.length,
          itemBuilder: (context, index) {
            final p = profils[index];
            return ListTile(
              title: Text(p['nom']),
              subtitle: Text(p['type']),
              trailing: Icon(Icons.security),
            );
          },
        );
      },
    );
  }
}

class ScenarioSimulationTab extends StatelessWidget {
  const ScenarioSimulationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getScenarioSimulations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erreur chargement scénarios"));
        }

        final scenarios = snapshot.data!;
        return ListView.builder(
          itemCount: scenarios.length,
          itemBuilder: (context, index) {
            final s = scenarios[index];
            return ListTile(
              title: Text(s['titre']),
              subtitle: Text("Objectif : ${s['objectif']}"),
            );
          },
        );
      },
    );
  }
}

class ResultatSimulationTab extends StatelessWidget {
  const ResultatSimulationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getResultatSimulations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erreur chargement résultats"));
        }

        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final r = results[index];
            return ListTile(
              title: Text("Simulation ID : ${r['idScenario']}"),
              subtitle: Text("Conclusion : ${r['conclusion']}"),
            );
          },
        );
      },
    );
  }
}
