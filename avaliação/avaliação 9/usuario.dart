class Usuario {
  final int id;
  final String nome;
  final String email;
  final String cidade;
  final String telefone;
  final String empresa;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.cidade,
    required this.telefone,
    required this.empresa,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['name'],
      email: json['email'],
      cidade: json['address']['city'],
      telefone: json['phone'],
      empresa: json['company']['name'],
    );
  }
}
