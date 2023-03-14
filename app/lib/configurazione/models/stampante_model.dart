// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';

class StampanteModel implements AbstractModel {
  int id_stampante;
  // int id_azienda;
  String? nome_stampante;
  String? desc_stampante;

  StampanteModel(
      {required this.id_stampante, this.nome_stampante, this.desc_stampante});

  factory StampanteModel.fromJson(Map<String, dynamic> map) {
    return StampanteModel(
        id_stampante: map["id_stampante"],
        nome_stampante: map["nome_stampante"],
        desc_stampante: map["desc_stampante"]);
  }

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_stampante": id_stampante,
      "nome_stampante": nome_stampante,
      "desc_stampante": desc_stampante
    };
  }
}
