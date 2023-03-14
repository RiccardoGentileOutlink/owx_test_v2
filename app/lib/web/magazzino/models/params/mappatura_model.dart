import 'dart:convert';

import 'package:ows_test_v2/generale/models/abstract_model.dart';

class MappaturaModel extends AbstractModel {
  List<ComponenteMappaturaModel> elementi;

  MappaturaModel({required this.elementi});

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "elementi": elementi.map((e) => e.toJson()).toList(),
    };
  }
}

class ComponenteMappaturaModel extends AbstractModel {
  String elemento;
  String codice;
  int quantita;
  String? descrizione;

  ComponenteMappaturaModel({required this.elemento, this.codice = '', this.quantita = 0});

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "elemento": elemento,
      "codice": codice,
      "quantita": quantita,
      "descrizione": descrizione,
    };
  }
}

class ResponseAnteprimaModel extends AbstractModel {
  String? error;
  String? serializedResult;

  List<RigaAnteprimaMappaturaModel> get listaRigheAnteprima {
    List a = jsonDecode(serializedResult!);
    return a.map((e) => RigaAnteprimaMappaturaModel.fromJson(e)).toList();
  }

  ResponseAnteprimaModel({this.serializedResult, this.error});

  factory ResponseAnteprimaModel.fromJson(Map<String, dynamic> json) {
    return ResponseAnteprimaModel(
      serializedResult: json["serializedResult"],
      error: json["error"],
    );
  }

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "serializedResult": serializedResult,
      "error": error,
    };
  }
}

class RigaAnteprimaMappaturaModel {
  String? magazzino;
  String? zona;
  String? corridoio;
  String? montante;
  String? piano;
  String? cella;

  RigaAnteprimaMappaturaModel({this.magazzino, this.zona, this.corridoio, this.montante, this.piano, this.cella});

  factory RigaAnteprimaMappaturaModel.fromJson(Map<String, dynamic> json) {
    return RigaAnteprimaMappaturaModel(
      magazzino: json["Magazzino"],
      zona: json["Zona"],
      corridoio: json["Corridoio"],
      montante: json["Montante"],
      piano: json["Piano"],
      cella: json["Cella"],
    );
  }
}
