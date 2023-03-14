// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';
import 'package:ows_test_v2/magazzino/models/zona_model.dart';

class CorridoioModel extends AbstractModel {
  int id_corridoio;
  String? cod_corridoio;
  String? desc_corridoio;
  String? cod_alias;
  int? id_magazzino;
  int? id_zona;
  DateTime? data_ins;
  DateTime? data_mod;

  // MagazzinoModel? magazzino; IL MAGAZZINO E' GIA DENTRO A ZONA MODEL QUINDI QUA SAREBBE RIDONDANTE
  ZonaModel? zona;

  CorridoioModel(
      {required this.id_corridoio,
      this.cod_corridoio,
      this.desc_corridoio,
      this.cod_alias,
      this.id_magazzino,
      this.id_zona,
      this.data_ins,
      this.data_mod,
      this.zona});

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_corridoio": id_corridoio,
      "cod_corridoio": cod_corridoio,
      "desc_corridoio": desc_corridoio,
      "cod_alias": cod_alias,
      "id_magazzino": id_magazzino,
      "id_zona": id_zona,
      "data_ins": data_ins,
      "data_mod": data_mod,
      "zona": zona?.toJson(),
    };
  }

  factory CorridoioModel.fromJson(Map<String, dynamic> json) {
    return CorridoioModel(
      id_corridoio: json["id_corridoio"],
      cod_corridoio: json["cod_corridoio"],
      desc_corridoio: json["desc_corridoio"],
      cod_alias: json["cod_alias"],
      id_magazzino: json["id_magazzino"],
      id_zona: json["id_zona"],
      data_ins: DateTime.tryParse(json["data_ins"] ?? ''),
      data_mod: DateTime.tryParse(json["data_mod"] ?? ''),
      zona: json["zona"] != null ? ZonaModel.fromJson(json["zona"]) : null,
    );
  }
}
