// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';
import 'package:ows_test_v2/magazzino/models/piano_model.dart';

class CellaModel extends AbstractModel {
  int id_cella;
  int id_azienda;
  String? cod;
  String? cod_cella;
  String? desc_cella;
  String? cod_alias;
  int? id_magazzino;
  int? id_zona;
  int? id_corridoio;
  int? id_montante;
  int? id_piano;
  DateTime? data_ins;
  DateTime? data_agg;
  String? sessione;
  int? ordinamento;

  PianoModel? piano;

  CellaModel({
    required this.id_cella,
    required this.id_azienda,
    this.cod,
    this.cod_cella,
    this.desc_cella,
    this.cod_alias,
    this.id_magazzino,
    this.id_zona,
    this.id_corridoio,
    this.id_montante,
    this.id_piano,
    this.data_ins,
    this.data_agg,
    this.sessione,
    this.ordinamento,
    this.piano,
  });

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_cella": id_cella,
      "id_azienda": id_azienda,
      "cod": cod,
      "cod_cella": cod_cella,
      "desc_cella": desc_cella,
      "cod_alias": cod_alias,
      "id_magazzino": id_magazzino,
      "id_zona": id_zona,
      "id_corridoio": id_corridoio,
      "id_montante": id_montante,
      "id_piano": id_piano,
      "data_ins": data_ins,
      "data_agg": data_agg,
      "sessione": sessione,
      "ordinamento": ordinamento,
      "piano": piano?.toJson(),
    };
  }

  factory CellaModel.fromJson(Map<String, dynamic> json) {
    return CellaModel(
      id_cella: json["id_cella"],
      id_azienda: json["id_azienda"],
      cod: json["cod"],
      cod_cella: json["cod_cella"],
      desc_cella: json["desc_cella"],
      cod_alias: json["cod_alias"],
      id_magazzino: json["id_magazzino"],
      id_zona: json["id_zona"],
      id_corridoio: json["id_corridoio"],
      id_montante: json["id_montante"],
      id_piano: json["id_piano"],
      data_ins: DateTime.tryParse(json["data_ins"] ?? ''),
      data_agg: DateTime.tryParse(json["data_agg"] ?? ''),
      sessione: json["sessione"],
      ordinamento: json["ordinamento"],
      piano: json["piano"] != null ? PianoModel.fromJson(json["piano"]) : null,
    );
  }
}
