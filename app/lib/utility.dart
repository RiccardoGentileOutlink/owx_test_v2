import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:ows_test_v2/autenticazione/providers/utente_provider.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/providers/error_provider.dart';
import 'package:ows_test_v2/generale/providers/server_provider.dart';
import 'package:ows_test_v2/generale/widgets/contenitore_messaggio.dart';
import 'package:ows_test_v2/generated/assets.gen.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static Future<bool> isOnline() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(DatiMemoria.url) != null) {
      return prefs.getString(DatiMemoria.url)!;
    }
    return '';
  }

  static String getUserToken() {
    return GetIt.I<UtenteProvider>().getToken();
  }

  static ServerProvider getServerProvider() {
    return GetIt.I<ServerProvider>();
  }

  static UtenteProvider getUtenteProvider() {
    return GetIt.I<UtenteProvider>();
  }

  static int getIdAzienda() {
    if (getUtenteProvider().azienda != null) {
      return getUtenteProvider().azienda!.id_azienda!;
    }
    return 0;
  }

  static ErrorProvider getErrorProvider(BuildContext context) {
    return Provider.of<ErrorProvider>(context, listen: false);
  }

  static void setErrore(BuildContext context, String errore,
      {String stack = ''}) {
    getErrorProvider(context).setErrore(errore, stack: stack);
  }

  static void mostraMessaggioSalvataggioEseguito(BuildContext context,
      {String? msg}) {
    msg ??= S.current.msg_salvataggio_eseguito.capitalize();
    double larghezzaSchermo = MediaQuery.of(context).size.width;
    double larghezza = 250;
    double margineLaterale = (larghezzaSchermo - larghezza) / 2;
    if (margineLaterale < 0) {
      margineLaterale = 0;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
        child: Text(msg),
      ),
      //margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 110, left: margineLaterale, right: margineLaterale),
      backgroundColor: Colors.blueGrey.withOpacity(0.8),
      //duration: const Duration(seconds: 5),
      //behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
    ));
  }

  static Future<bool?> _mostraDialog(
      BuildContext context, String titolo, String messaggio, String tipo) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Visibility(
            visible: titolo.isNotEmpty,
            child: Row(
              children: [
                Icon(
                  tipo == ContenitoreMessaggio.tipoErrore
                      ? Icons.error_outline
                      : Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: ValoriDefault.defaultPadding),
                  child: Text(
                    titolo.capitalize(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          content: SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width > 500
                  ? 500
                  : MediaQuery.of(context).size.width * 0.9,
              child: ContenitoreMessaggio(testo: messaggio, tipo: tipo)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(S.current.ok.toUpperCase()))
          ],
        );
      },
    );
  }

  static Future<bool?> mostraInfoDialog(
      BuildContext context, String titolo, String messaggio) {
    return _mostraDialog(
        context, titolo, messaggio, ContenitoreMessaggio.tipoMessaggio);
  }

  static Future<bool?> mostraAlertDialog(
      BuildContext context, String titolo, String messaggio) {
    return _mostraDialog(
        context, titolo, messaggio, ContenitoreMessaggio.tipoAlert);
  }

/*
* da utilizzare nelle pagine popup, nelle altre pagine utilizzare setErrore
*/
  static Future<bool?> mostraErrorDialog(
      BuildContext context, String titolo, String messaggio) {
    return _mostraDialog(
        context, titolo, messaggio, ContenitoreMessaggio.tipoErrore);
  }

  static Future<bool?> mostraConfermaDialog(
      BuildContext context, String titolo, String messaggio) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Visibility(
            visible: titolo.isNotEmpty,
            child: Row(
              children: [
                Icon(
                  Icons.info_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: ValoriDefault.defaultPadding),
                  child: Text(
                    titolo.capitalize(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          content: Text(messaggio),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(S.current.si.toUpperCase())),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(S.current.no.toUpperCase()))
          ],
        );
      },
    );
  }

  static Future<bool?> mostraPageDialog(BuildContext context,
      {required Widget pagina,
      double? larghezza,
      double? altezza,
      bool? barrierDismissible}) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: LayoutBuilder(
            builder: (context, size) {
              return SizedBox(
                width: larghezza ??
                    max(500, MediaQuery.of(context).size.width * 0.5),
                height: altezza ?? MediaQuery.of(context).size.height * 0.9,
                child: pagina,
              );
            },
          ),
        );
      },
    );
  }

  static String getLingua() {
    return 'it';
  }

  static Future<String> getParametroConfigurazione(String paramName) async {
    try {
      String jsonString =
          await rootBundle.loadString(Assets.config, cache: false);

      dynamic jsonMap = jsonDecode(jsonString);
      return jsonMap[paramName];
    } on Error catch (_) {
      return "";
    }
  }
}

class ValoriDefault {
  static const double defaultPadding = 8.0;
  static const double defaultLarghezza = 400;
  static const double defaultALtezzaDrawerWeb = 64;
  static const double defaultALtezzaDrawerMobile = 92;
  static const double defaultAltezzaPulsante = 50;
  static const double defaultAltezzaIconaInfo = 18;
}

//classe utilizzata per i nomi delle impostazioni da salvare in SharedPreferences
class DatiMemoria {
  static const String url = "url";
  static const String utente = "utente"; //il json dell'utente
  static const String id_azienda = "id_azienda";
  static const String ragSocAzienda = "ragSocAzienda";
  static const String username = "username";
  static const String password = "password";
  static const String ricordaLogin = "ricordaLogin";
}
