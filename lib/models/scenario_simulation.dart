class ScenarioSimulation {
  final int id;
  final String titre;
  final String description;
  final String contexte;
  final String objectif;
  final String typeActeur;
  final String difficulte;

  ScenarioSimulation({
    required this.id,
    required this.titre,
    required this.description,
    required this.contexte,
    required this.objectif,
    required this.typeActeur,
    required this.difficulte,
  });

  factory ScenarioSimulation.fromJson(Map<String, dynamic> json) {
    return ScenarioSimulation(
      id: json['idScenario'],
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      contexte: json['contexte'] ?? '',
      objectif: json['objectif'] ?? '',
      typeActeur: json['typeActeur'] ?? '',
      difficulte: json['difficulte'] ?? '',
    );
  }
}
