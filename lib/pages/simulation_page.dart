import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/simulation_tabs.dart';
import 'package:flutter_chat_app/widgets/custom_app_bar.dart';
import 'package:flutter_chat_app/services/api_service.dart';
import 'package:flutter_chat_app/utils/secure_storage.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  void _logout() async {
    await SecureStorage().clearAll(); // ou deleteToken + deleteUserId
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(title: "Simulation", onLogout: _logout),
        body: Column(
          children: const [
            TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Profils Attaquants'),
                Tab(text: 'Scénarios'),
                Tab(text: 'Résultats'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProfilAttaquantTab(),
                  ScenarioSimulationTab(),
                  ResultatSimulationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
