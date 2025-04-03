class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String? derniereActivite;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.derniereActivite,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['idUtilisateur'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      role: json['role'],
      derniereActivite: json['derniereActivite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUtilisateur': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
      'derniereActivite': derniereActivite,
    };
  }

  @override
  String toString() {
    return '$prenom $nom ($email)';
  }
}
