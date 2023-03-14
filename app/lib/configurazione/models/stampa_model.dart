// ignore_for_file: non_constant_identifier_names
import 'package:ows_test_v2/configurazione/models/stampante_model.dart';
import 'package:ows_test_v2/generale/models/abstract_model.dart';

class StampaModel implements AbstractModel {
  static const String stampaEtichettaCella = "ETCELLA";
  static const String stampaEtichettaUDC = "ETUDC";

  int id_stampa;
  int? id_azienda;
  String? cod_stampa;
  String? desc_stampa;
  int? id_stampante_def;
  int? id_utente_ins;
  DateTime? data_ins;
  int? id_utente_agg;
  DateTime? data_agg;

  StampanteModel? stampante_def;

  StampaModel(
      {required this.id_stampa,
      this.id_azienda,
      this.cod_stampa,
      this.desc_stampa,
      this.id_stampante_def,
      this.id_utente_ins,
      this.data_ins,
      this.id_utente_agg,
      this.data_agg,
      this.stampante_def});

  factory StampaModel.fromJson(Map<String, dynamic> map) {
    return StampaModel(
      id_stampa: map['id_stampa'],
      id_azienda: map['id_azienda'],
      cod_stampa: map['cod_stampa'],
      desc_stampa: map['desc_stampa'],
      id_stampante_def: map['id_stampante_def'],
      id_utente_ins: map['id_utente_ins'],
      data_ins: DateTime.tryParse(map['data_ins'] ?? ''),
      id_utente_agg: map['id_utente_agg'],
      data_agg: DateTime.tryParse(map['data_agg'] ?? ''),
      stampante_def: map['stampante_def'] != null
          ? StampanteModel.fromJson(map["stampante_def"])
          : null,
    );
  }

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "id_stampa": id_stampa,
      "id_azienda": id_azienda,
      "cod_stampa": cod_stampa,
      "desc_stampa": desc_stampa,
      "id_stampante_def": id_stampante_def,
      "id_utente_ins": id_utente_ins,
      "data_ins": data_ins,
      "id_utente_agg": id_utente_agg,
      "data_agg": data_agg,
      "stampante_def": stampante_def?.toJson(),
    };
  }
}
