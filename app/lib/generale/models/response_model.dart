import 'dart:typed_data';

import 'package:ows_test_v2/generale/models/abstract_model.dart';

class ResponseModel extends AbstractModel {
  String? errore;
  Map<String, dynamic>? data;
  List<Map<String, dynamic>>? listData;
  bool? resultOk;
  Uint8List? bytes;

  List<String>? get listStringData {
    if (listData != null) {
      return listData!.map<String>((e) => e.containsKey("value") ? e["value"] : '').toList();
    }
    return null;
  }

  ResponseModel({this.errore, this.data, this.listData, this.resultOk, this.bytes});

  @override
  Map<String, dynamic>? toJson() {
    return <String, dynamic>{
      "errore": errore,
      "data": data,
      "listData": listData,
      "resultOk": resultOk,
      "bytes": bytes,
    };
  }
}
