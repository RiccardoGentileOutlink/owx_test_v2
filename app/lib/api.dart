class ApiAutenticazione {
  static const String controller = "api/autenticazione";
  static const String login = "$controller/login";
  static const String creaUtente = "$controller/creaUtente";
  static const String modificaUtente = "$controller/modificaUtente";
  static const String getUtenti = "$controller/getUtenti";
  static const String getUtente = "$controller/getUtente";
  static const String eliminaUtente = "$controller/eliminaUtente";
  static const String getAziende = "$controller/getAziende";
}

class ApiMagazzino {
  static const String controller = "api/magazzino";
  static const String getMagazzini = "$controller/getMagazzini";
  static const String anteprimaMappatura = "$controller/anteprimaMappatura";
  static const String creaMappatura = "$controller/creaMappatura";
  static const String getCelle = "$controller/getCelle";
  static const String stampaEtichetteCelle = "$controller/stampaEtichetteCelle";
  static const String stampaEtichetteUDC = "$controller/stampaEtichetteUDC";
  static const String eliminaCelle = "$controller/eliminaCelle";
  static const String getTipoUdc = "$controller/getTipoUdc";
  static const String generaUdc = "$controller/generaUdc";
  static const String getUdc = "$controller/getUdc";
}

class ApiConfigurazione {
  static const String controller = "api/configurazione";
  static const String getParametri = "$controller/getParametri";
  static const String salvaParametri = "$controller/salvaParametri";
  static const String getStampantiServer = "$controller/getStampantiServer";
  static const String getStampanti = "$controller/getStampanti";
  static const String getStampante = "$controller/getStampante";
  static const String salvaStampante = "$controller/salvaStampante";
  static const String eliminaStampante = "$controller/eliminaStampante"; 
  static const String getStampe = "$controller/getStampe";
  static const String getStampa = "$controller/getStampa";
  static const String salvaStampa = "$controller/salvaStampa";
}
