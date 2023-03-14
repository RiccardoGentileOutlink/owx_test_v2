// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';
import 'package:ows_test_v2/magazzino/models/corridoio_model.dart';

class MontanteModel implements AbstractModel {
  int id_montante;
  String? cod_montante;
  String? desc_montante;
  String? cod_alias;
  int? id_magazzino;
  int? id_zona;
  int? id_corridoio;
  DateTime? data_ins;
  DateTime? data_agg;

  CorridoioModel? corridoio;

  MontanteModel({
    required this.id_montante,
    this.cod_montante,
    this.desc_montante,
    this.cod_alias,
    this.id_magazzino,
    this.id_zona,
    this.id_corridoio,
    this.data_ins,
    this.data_agg,
    this.corridoio,
  });

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_montante": id_montante,
      "cod_montante": cod_montante,
      "desc_montante": desc_montante,
      "cod_alias": cod_alias,
      "id_magazzino": id_magazzino,
      "id_zona": id_zona,
      "id_corridoio": id_corridoio,
      "data_ins": data_ins,
      "data_agg": data_agg,
      "corridoio": corridoio?.toJson(),
    };
  }

  factory MontanteModel.fromJson(Map<String, dynamic> json) {
    return MontanteModel(
      id_montante: json["id_montante"],
      cod_montante: json["cod_montante"],
      desc_montante: json["desc_montante"],
      cod_alias: json["cod_alias"],
      id_magazzino: json["id_magazzino"],
      id_zona: json["id_zona"],
      id_corridoio: json["id_corridoio"],
      data_ins: DateTime.tryParse(json["data_ins"] ?? ''),
      data_agg: DateTime.tryParse(json["data_agg"] ?? ''),
      corridoio: json["corridoio"] != null ? CorridoioModel.fromJson(json["corridoio"]) : null,
    );
  }
}
