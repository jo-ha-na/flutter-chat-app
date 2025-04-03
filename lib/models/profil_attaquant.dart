class ProfilAttaquant {
  final int id;
  final String nom;
  final String type;
  final String description;
  final String tactique;
  final String methode;

  ProfilAttaquant({
    required this.id,
    required this.nom,
    required this.type,
    required this.description,
    required this.tactique,
    required this.methode,
  });

  factory ProfilAttaquant.fromJson(Map<String, dynamic> json) {
    return ProfilAttaquant(
      id: json['id'],
      nom: json['nom'],
      type: json['type'],
      description: json['description'],
      tactique: json['tactique'],
      methode: json['methode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'description': description,
      'tactique': tactique,
      'methode': methode,
    };
  }
}
