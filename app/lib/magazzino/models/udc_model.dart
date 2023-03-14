// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/magazzino/models/tipo_udc_model.dart';

class UdcModel {
  int id_udc;
  int id_azienda;
  String? cod_udc;
  int? id_tipo_udc;
  String? sessione;
  DateTime? data_ins;
  DateTime? data_agg;
  int? id_utente_ins;
  int? id_utente_agg;

  TipoUdcModel? tipoUdc;

  UdcModel({
    required this.id_udc,
    required this.id_azienda,
    this.cod_udc,
    this.id_tipo_udc,
    this.sessione,
    this.data_agg,
    this.data_ins,
    this.id_utente_ins,
    this.id_utente_agg,
    this.tipoUdc,
  });

  factory UdcModel.fromJson(Map<String, dynamic> json) => UdcModel(
        id_udc: json["id_udc"],
        id_azienda: json["id_azienda"],
        cod_udc: json["cod_udc"],
        id_tipo_udc: json["id_tipo_udc"],
        sessione: json["sessione"],
        data_ins: DateTime.tryParse(json["data_ins"] ?? ''),
        data_agg: DateTime.tryParse(json["data_agg"] ?? ''),
        id_utente_ins: json["id_utente_ins"],
        id_utente_agg: json["id_utente_agg"],
        tipoUdc: json["tipo_udc"] != null ? TipoUdcModel.fromJson(json["tipo_udc"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id_udc": id_udc,
        "id_azienda": id_azienda,
        "cod_udc": cod_udc,
        "id_tipo_udc": id_tipo_udc,
        "sessione": sessione,
        "data_ins": data_ins,
        "data_agg": data_agg,
        "id_utente_ins": id_utente_ins,
        "id_utente_agg": id_utente_agg,
        "tipo_udc": tipoUdc?.toJson(),
      };
}
