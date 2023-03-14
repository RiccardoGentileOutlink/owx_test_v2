// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';
import 'package:ows_test_v2/magazzino/models/magazzino_model.dart';

class ZonaModel extends AbstractModel {
  int id_zona;
  String? cod_zona;
  String? desc_zona;
  String? cod_alias;
  int? id_magazzino;
  DateTime? data_ins;
  DateTime? data_mod;

  MagazzinoModel? magazzino;

  ZonaModel({
    required this.id_zona,
    this.cod_zona,
    this.desc_zona,
    this.cod_alias,
    this.id_magazzino,
    this.data_ins,
    this.data_mod,
    this.magazzino,
  });

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_zona": id_zona,
      "cod_zona": cod_zona,
      "desc_zona": desc_zona,
      "cod_alias": cod_alias,
      "id_magazzino": id_magazzino,
      "data_ins": data_ins,
      "data_mod": data_mod,
      "magazzino": magazzino?.toJson(),
    };
  }

  factory ZonaModel.fromJson(Map<String, dynamic> json) {
    return ZonaModel(
      id_zona: json["id_zona"],
      cod_zona: json["cod_zona"],
      desc_zona: json["desc_zona"],
      cod_alias: json["cod_alias"],
      id_magazzino: json["id_magazzino"],
      data_ins: DateTime.tryParse(json["data_ins"] ?? ''),
      data_mod: DateTime.tryParse(json["data_mod"] ?? ''),
      magazzino: json["magazzino"] != null ? MagazzinoModel.fromJson(json["magazzino"]) : null,
    );
  }
}
