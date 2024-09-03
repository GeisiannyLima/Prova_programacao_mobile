import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class User {
  final String email;
  final String password;
  final String name;
  final double rendaFixa;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.rendaFixa,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      rendaFixa: json['rendaFixa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'rendaFixa': rendaFixa,
    };
  }
}

class Grupo {
  final int id;
  final String name;
  final List<String> users;

  Grupo({
    required this.id,
    required this.name,
    required this.users,
  });

  // Converte um objeto Grupo para um mapa JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'users': users,
      };

  // Converte um mapa JSON para um objeto Grupo
  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      name: json['name'],
      users: List<String>.from(json['users']),
    );
  }
}

class Expense {
  final int id;
  final String userEmail;
  final String description;
  final double amount;

  Expense({
    required this.id,
    required this.userEmail,
    required this.description,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      userEmail: json['userEmail'],
      description: json['description'],
      amount: json['amount'],
    );
  }
}
