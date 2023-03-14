import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:ows_test_v2/autenticazione/providers/utente_provider.dart';

class ErrorProvider extends ChangeNotifier {
  String? errore;
  String? stackTrace;

  void setErrore(String? err, {String? stack = ''}) {
    if (err != null && GetIt.I<UtenteProvider>().isLoggato) {
      errore = err;
      if (errore == null) {
        stackTrace = null;
      } else {
        stackTrace = stack;
      }

      notifyListeners();
    } else {
      if (err == null) {
        errore = err;
        stackTrace = null;

        notifyListeners();
      }
    }
  }
}
