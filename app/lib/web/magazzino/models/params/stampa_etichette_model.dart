// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';

class ParametriGeneraliStampaModel extends AbstractModel {
  static const String verticale = "V";
  static const String orizzontale = "O";

  static const String a4 = "A4";
  static const String a5 = "A5";
  static const String a6 = "A6";

  final String orientamento;
  final String dimensionePagina;
  final int? id_stampante;
  final int quantita;

  ParametriGeneraliStampaModel(
      {this.orientamento = orizzontale,
      this.dimensionePagina = a4,
      this.id_stampante,
      this.quantita = 1});

  factory ParametriGeneraliStampaModel.def() {
    return ParametriGeneraliStampaModel();
  }

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "orientamento": orientamento,
      "dimensionePagina": dimensionePagina,
      "quantita": quantita,
      "id_stampante": id_stampante,
    };
  }
}

//trasformare in int
class StampaEtichetteCelleModel extends AbstractModel {
  List<String> idCelle;
  ParametriGeneraliStampaModel parametriGeneraliStampa;

  StampaEtichetteCelleModel(
      {required this.idCelle, required this.parametriGeneraliStampa});

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "idCelle": idCelle,
      "parametriGeneraliStampa": parametriGeneraliStampa,
    };
  }
}

class StampaEtichetteUDCModel extends AbstractModel {
  List<int> idUDC;
  ParametriGeneraliStampaModel parametriGeneraliStampa;

  StampaEtichetteUDCModel(
      {required this.idUDC, required this.parametriGeneraliStampa});

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "idUDC": idUDC,
      "parametriGeneraliStampa": parametriGeneraliStampa,
    };
  }
}
