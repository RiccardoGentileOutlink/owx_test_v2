import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/autenticazione/models/azienda_model.dart';
import 'package:ows_test_v2/autenticazione/models/utente_model.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';

import 'package:ows_test_v2/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generale/widgets/menu_laterale.dart';

class UtenteProvider extends ChangeNotifier {
  UtenteModel? utente;
  bool isLoggato = false;
  bool mostraMessaggioDisconnesso = false;

  AziendaModel? azienda;

  Future<ResponseModel> accedi(UtenteModel ut) async {
    ResponseModel res = await Utility.getServerProvider().getData(ApiAutenticazione.login, ut.toJson(), mostraProgress: false);

    if (res.errore == null) {
      utente = UtenteModel.fromJson(res.data!);
      Utility.getUtenteProvider().utente = utente;
      SharedPreferences.getInstance().then((value) {
        value.setString(DatiMemoria.utente, jsonEncode(utente!.toJson()));
      });
    }

    return res;
  }

  Future<bool> disconnetti({bool mostraAlert = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(DatiMemoria.utente);
    utente = UtenteModel(
      id_utente: 0,
      username: '',
      password: '',
      token: '',
      tipo_utente: TipoUtente.operatoreMagazzino,
    );
    isLoggato = false;
    mostraMessaggioDisconnesso = mostraAlert;
    GetIt.I<MenuLateraleStato>().selezionato = "";
    notifyListeners();
    return isLoggato;
  }

  Future<void> fromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(DatiMemoria.utente)) {
      utente = UtenteModel.fromJson(jsonDecode(prefs.getString(DatiMemoria.utente)!));
    } else {
      utente = UtenteModel(
        id_utente: 0,
        username: '',
        password: '',
        tipo_utente: TipoUtente.operatoreMagazzino,
      );
    }
    if (utente!.id_utente != 0) {
      isLoggato = true;
    } else {
      isLoggato = false;
    }
    Utility.getUtenteProvider().utente = utente;
    if (prefs.containsKey(DatiMemoria.id_azienda)) {
      AziendaModel az = AziendaModel(id_azienda: prefs.getInt(DatiMemoria.id_azienda), ragione_sociale: prefs.getString(DatiMemoria.ragSocAzienda));
      Utility.getUtenteProvider().azienda = az;
    }
  }

  String getToken() {
    if (utente != null && utente!.token != null) {
      return utente!.token!;
    }
    return '';
  }

  void setLoggato() {
    isLoggato = true;
    mostraMessaggioDisconnesso = false;
    notifyListeners();
  }

  TipoUtente get tipoUtente {
    if (utente != null) {
      return utente!.tipo_utente;
    } else {
      return TipoUtente.operatoreMagazzino;
    }
  }
}
