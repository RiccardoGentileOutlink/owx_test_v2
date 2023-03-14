// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import '../../generale/models/abstract_model.dart';

class Parametro {
  static String permetti_allocazione_sfus = "ALSFU";
  static String usa_etichette_udc_esterne = "ETEST";
  static String accetta_articoli_no_lista = "ARTNL";
  static String permetti_prelievo_senza_assegnazione = "NOASS";
  static String periodo_movimentazioni = "PERMO";
}

class ParametroModel implements AbstractModel {
  late String? cod_parametro;
  late String? desc_parametro;
  late String? valore;

  ParametroModel({
    this.cod_parametro,
    this.desc_parametro,
    this.valore,
  });

  factory ParametroModel.fromJson(Map<String, dynamic> json) {
    return ParametroModel(
      cod_parametro: json["cod_parametro"],
      desc_parametro: json["desc_parametro"],
      valore: json["valore"],
    );
  }
  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "cod_parametro": cod_parametro,
      "desc_parametro": desc_parametro,
      "valore": valore,
    };
  }
}

class PeriodoMovimentazioni {
  static const String anno = "A";
  static const String mese = "M";
  static const String trimestre = "T";
  static const String settimana = "S";
  static const String giorno = "G";
}
