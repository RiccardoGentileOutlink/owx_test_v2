// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';
import 'package:ows_test_v2/magazzino/models/montante_model.dart';

class PianoModel extends AbstractModel {
  int id_piano;
  String? cod_piano;
  String? desc_piano;
  String? cod_alias;
  int? id_magazzino;
  int? id_zona;
  int? id_corridoio;
  int? id_montante;
  DateTime? data_ins;
  DateTime? data_agg;

  MontanteModel? montante;

  PianoModel({
    required this.id_piano,
    this.cod_piano,
    this.desc_piano,
    this.cod_alias,
    this.id_magazzino,
    this.id_zona,
    this.id_corridoio,
    this.id_montante,
    this.data_ins,
    this.data_agg,
    this.montante,
  });

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_piano": id_piano,
      "cod_piano": cod_piano,
      "desc_piano": desc_piano,
      "cod_alias": cod_alias,
      "id_magazzino": id_magazzino,
      "id_zona": id_zona,
      "id_corridoio": id_corridoio,
      "id_montante": id_montante,
      "data_ins": data_ins,
      "data_agg": data_agg,
      "montante": montante?.toJson(),
    };
  }

  factory PianoModel.fromJson(Map<String, dynamic> json) {
    return PianoModel(
      id_piano: json["id_piano"],
      cod_piano: json["cod_piano"],
      desc_piano: json["desc_piano"],
      cod_alias: json["cod_alias"],
      id_magazzino: json["id_magazzino"],
      id_zona: json["id_zona"],
      id_corridoio: json["id_corridoio"],
      id_montante: json["id_montante"],
      data_ins: DateTime.tryParse(json["data_ins"] ?? ''),
      data_agg: DateTime.tryParse(json["data_agg"] ?? ''),
      montante: json["montante"] != null ? MontanteModel.fromJson(json["montante"]) : null,
    );
  }
}
