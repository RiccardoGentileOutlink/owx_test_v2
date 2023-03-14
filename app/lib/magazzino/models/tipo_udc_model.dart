// ignore_for_file: non_constant_identifier_names

import 'package:ows_test_v2/generale/models/abstract_model.dart';

class TipoUdcModel extends AbstractModel {
  int? id_tipo_udc;
  String? cod_tipo_udc;
  String? desc_tipo_udc;
  bool? uscita;

  TipoUdcModel({
    this.id_tipo_udc,
    this.cod_tipo_udc,
    this.desc_tipo_udc,
    this.uscita,
  });

  factory TipoUdcModel.fromJson(Map<String, dynamic> json) {
    return TipoUdcModel(
      id_tipo_udc: json['id_tipo_udc'],
      cod_tipo_udc: json['cod_tipo_udc'],
      desc_tipo_udc: json['desc_tipo_udc'],
      uscita: json['uscita'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id_tipo_udc': id_tipo_udc,
      'cod_tipo_udc': cod_tipo_udc,
      'desc_tipo_udc': desc_tipo_udc,
      'uscita': uscita,
    };
  }
}
