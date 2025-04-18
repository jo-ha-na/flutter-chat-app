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
      id: json['idUtilisateur'] ?? 0,
      nom: json['nom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      derniereActivite: json['derniereActivite']?.toString(),
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
