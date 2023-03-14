// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';

class MagazzinoModel implements AbstractModel {
  int id_magazzino;
  int id_azienda;
  String? cod_magazzino;
  String? desc_magazzino;
  int ordinamento;
  DateTime? data_ins;
  DateTime? data_mod;

  String get descrizioneConCodice {
    return '$cod_magazzino - $desc_magazzino';
  }

  MagazzinoModel({
    required this.id_magazzino,
    required this.id_azienda,
    this.cod_magazzino,
    this.desc_magazzino,
    required this.ordinamento,
    this.data_ins,
    this.data_mod,
  });

  factory MagazzinoModel.fromJson(Map<String, dynamic> json) {
    return MagazzinoModel(
      id_magazzino: json['id_magazzino'],
      id_azienda: json["id_azienda"],
      cod_magazzino: json["cod_magazzino"],
      desc_magazzino: json["desc_magazzino"],
      ordinamento: json["ordinamento"],
      data_ins: DateTime.tryParse(json["data_ins"] ?? ''),
      data_mod: DateTime.tryParse(json["data_mod"] ?? ''),
    );
  }

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_magazzino": id_magazzino,
      "id_azienda": id_azienda,
      "cod_magazzino": cod_magazzino,
      "desc_magazzino": desc_magazzino,
      "ordinamento": ordinamento,
      "data_ins": data_ins,
      "data_mod": data_mod,
    };
  }
}
