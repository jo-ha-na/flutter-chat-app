class ProfilDefenseur {
  final int idProfilDefenseur;
  final String nom;
  final String type;
  final String description;

  ProfilDefenseur({
    required this.idProfilDefenseur,
    required this.nom,
    required this.type,
    required this.description,
  });

  factory ProfilDefenseur.fromJson(Map<String, dynamic> json) {
    return ProfilDefenseur(
      idProfilDefenseur: json['idProfilDefenseur'],
      nom: json['nom'],
      type: json['type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProfilDefenseur': idProfilDefenseur,
      'nom': nom,
      'type': type,
      'description': description,
    };
  }
}
