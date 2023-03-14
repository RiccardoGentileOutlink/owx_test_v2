// ignore_for_file: non_constant_identifier_names

import '../../generale/models/abstract_model.dart';

class AziendaModel implements AbstractModel {
  late int? id_azienda;
  late String? ragione_sociale;

  AziendaModel({
    this.id_azienda,
    this.ragione_sociale,
  });

  factory AziendaModel.fromJson(Map<String, dynamic> json) {
    return AziendaModel(
      id_azienda: json["id_azienda"],
      ragione_sociale: json["ragione_sociale"],
    );
  }
  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_azienda": id_azienda,
      "ragione_sociale": ragione_sociale,
    };
  }
}
