import 'dart:convert';

// 14-agregacao.dart
// Agregação e Composição

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  // ADICIONADO
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  // ADICIONADO
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes,
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  // ADICIONADO
  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios,
    };
  }
}

void main() {
  // 1. Criar varios objetos Dependentes

  Dependente dependente1 = Dependente("João");
  Dependente dependente2 = Dependente("Maria");
  Dependente dependente3 = Dependente("Pedro");
  Dependente dependente4 = Dependente("Ana");

  // 2. Criar varios objetos Funcionarios

  Funcionario funcionario1 = Funcionario(
    "Carlos",
    [dependente1, dependente2],
  );

  Funcionario funcionario2 = Funcionario(
    "Fernanda",
    [dependente3],
  );

  Funcionario funcionario3 = Funcionario(
    "Roberto",
    [dependente4],
  );


  List<Funcionario> funcionarios = [
    funcionario1,
    funcionario2,
    funcionario3,
  ];

  EquipeProjeto equipeProjeto = EquipeProjeto(
    "Projeto Dart",
    funcionarios,
  );

  print(jsonEncode(equipeProjeto));
}
