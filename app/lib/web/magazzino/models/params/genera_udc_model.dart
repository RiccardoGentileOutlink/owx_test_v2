// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';

class GeneraUdcModel extends AbstractModel {
  int id_tipo_udc;
  int quantita;
  bool stampa;

  GeneraUdcModel({required this.id_tipo_udc, required this.quantita, this.stampa = false});

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_tipo_udc": id_tipo_udc,
      "quantita": quantita,
      "stampa": stampa,
    };
  }
}
