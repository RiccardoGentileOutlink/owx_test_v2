// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';

enum TipoUtente {
  admin(1),
  responabileMagazzino(2),
  operatoreMagazzino(3);

  const TipoUtente(this.value);
  final int value;

  static TipoUtente fromValue(int value) {
    if (value == 1) {
      return TipoUtente.admin;
    }
    if (value == 2) {
      return TipoUtente.responabileMagazzino;
    }
    if (value == 3) {
      return TipoUtente.operatoreMagazzino;
    }
    return TipoUtente.operatoreMagazzino;
  }
}

class UtenteModel implements AbstractModel {
  late int id_utente;
  late String? nome;
  late String? cognome;
  late String? mail;
  late String? username;
  late String? password;
  late String? token;
  late TipoUtente tipo_utente;
  late bool attivo;
  late int? id_azienda_sel;

  String get nomeECognome {
    String parteNome = nome ?? '';
    String parteCognome = cognome ?? '';
    return '$parteNome $parteCognome';
  }

  UtenteModel({
    this.id_utente = 0,
    this.nome,
    this.cognome,
    this.mail,
    this.username,
    this.password,
    this.token = '',
    this.tipo_utente = TipoUtente.operatoreMagazzino,
    this.attivo = false,
    this.id_azienda_sel,
  });

  factory UtenteModel.copyFrom(UtenteModel login) {
    return UtenteModel(
      id_utente: login.id_utente,
      nome: login.nome,
      cognome: login.cognome,
      mail: login.mail,
      username: login.username,
      password: login.password,
      token: login.token,
      tipo_utente: login.tipo_utente,
      attivo: login.attivo,
      id_azienda_sel: login.id_azienda_sel,
    );
  }

  factory UtenteModel.fromJson(Map<String, dynamic> json) {
    return UtenteModel(
      id_utente: json["id_utente"],
      nome: json["nome"],
      cognome: json["cognome"],
      mail: json["mail"],
      username: json["username"],
      password: "",
      token: json["token"],
      tipo_utente: TipoUtente.fromValue(json["tipo_utente"]),
      attivo: json['attivo'],
      id_azienda_sel: json['id_azienda_sel'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id_utente": id_utente,
      "nome": nome,
      "cognome": cognome,
      "mail": mail,
      "username": username,
      "password": password,
      "token": token,
      "tipo_utente": tipo_utente.value,
      "attivo": attivo,
      "id_azienda_sel": id_azienda_sel,
    };
  }
}
