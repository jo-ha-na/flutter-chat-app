class ResultatSimulation {
  final int id;
  final int idScenario;
  final int idUtilisateur;
  final String date;
  final String conclusion;

  ResultatSimulation({
    required this.id,
    required this.idScenario,
    required this.idUtilisateur,
    required this.date,
    required this.conclusion,
  });

  factory ResultatSimulation.fromJson(Map<String, dynamic> json) {
    return ResultatSimulation(
      id: json['id'] ?? json['idResultat'] ?? 0,
      idScenario: json['idScenario'],
      idUtilisateur: json['idUtilisateur'],
      date: json['date'],
      conclusion: json['conclusion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idScenario': idScenario,
      'idUtilisateur': idUtilisateur,
      'date': date,
      'conclusion': conclusion,
    };
  }
}
