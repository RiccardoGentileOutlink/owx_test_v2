// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// ``
  String get accedi {
    return Intl.message(
      '',
      name: 'accedi',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get logout {
    return Intl.message(
      '',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get username {
    return Intl.message(
      '',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get password {
    return Intl.message(
      '',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get si {
    return Intl.message(
      '',
      name: 'si',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get no {
    return Intl.message(
      '',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get ok {
    return Intl.message(
      '',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get annulla {
    return Intl.message(
      '',
      name: 'annulla',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get url_server {
    return Intl.message(
      '',
      name: 'url_server',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get test_connessione {
    return Intl.message(
      '',
      name: 'test_connessione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get salva_ed_esci {
    return Intl.message(
      '',
      name: 'salva_ed_esci',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get salva {
    return Intl.message(
      '',
      name: 'salva',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get usa_https {
    return Intl.message(
      '',
      name: 'usa_https',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get test_superato {
    return Intl.message(
      '',
      name: 'test_superato',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get test_non_superato {
    return Intl.message(
      '',
      name: 'test_non_superato',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get menu {
    return Intl.message(
      '',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get configura_server {
    return Intl.message(
      '',
      name: 'configura_server',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get versione {
    return Intl.message(
      '',
      name: 'versione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get ingresso_merce {
    return Intl.message(
      '',
      name: 'ingresso_merce',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get uscita_merce {
    return Intl.message(
      '',
      name: 'uscita_merce',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get inventario {
    return Intl.message(
      '',
      name: 'inventario',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get mappatura_magazzino {
    return Intl.message(
      '',
      name: 'mappatura_magazzino',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get magazzino {
    return Intl.message(
      '',
      name: 'magazzino',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get gestione_utenti {
    return Intl.message(
      '',
      name: 'gestione_utenti',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get creazione {
    return Intl.message(
      '',
      name: 'creazione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get anagrafica_celle {
    return Intl.message(
      '',
      name: 'anagrafica_celle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get anteprima {
    return Intl.message(
      '',
      name: 'anteprima',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get crea_celle {
    return Intl.message(
      '',
      name: 'crea_celle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get download {
    return Intl.message(
      '',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get stampa {
    return Intl.message(
      '',
      name: 'stampa',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get esporta {
    return Intl.message(
      '',
      name: 'esporta',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get caricamento {
    return Intl.message(
      '',
      name: 'caricamento',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get errore {
    return Intl.message(
      '',
      name: 'errore',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get configurazioni {
    return Intl.message(
      '',
      name: 'configurazioni',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get dettaglio {
    return Intl.message(
      '',
      name: 'dettaglio',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get zona {
    return Intl.message(
      '',
      name: 'zona',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get corridoio {
    return Intl.message(
      '',
      name: 'corridoio',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get montante {
    return Intl.message(
      '',
      name: 'montante',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get piano {
    return Intl.message(
      '',
      name: 'piano',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get cella {
    return Intl.message(
      '',
      name: 'cella',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get codice {
    return Intl.message(
      '',
      name: 'codice',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get quantita {
    return Intl.message(
      '',
      name: 'quantita',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get descrizione {
    return Intl.message(
      '',
      name: 'descrizione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get attenzione {
    return Intl.message(
      '',
      name: 'attenzione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get anteprima_celle_in_creazione {
    return Intl.message(
      '',
      name: 'anteprima_celle_in_creazione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get esporta_csv {
    return Intl.message(
      '',
      name: 'esporta_csv',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get esporta_excel {
    return Intl.message(
      '',
      name: 'esporta_excel',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get esporta_pdf {
    return Intl.message(
      '',
      name: 'esporta_pdf',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get data_inserimento {
    return Intl.message(
      '',
      name: 'data_inserimento',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get data_modifica {
    return Intl.message(
      '',
      name: 'data_modifica',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get nuovo_utente {
    return Intl.message(
      '',
      name: 'nuovo_utente',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get modifica_utente {
    return Intl.message(
      '',
      name: 'modifica_utente',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get chiudi {
    return Intl.message(
      '',
      name: 'chiudi',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get nome {
    return Intl.message(
      '',
      name: 'nome',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get cognome {
    return Intl.message(
      '',
      name: 'cognome',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get mail {
    return Intl.message(
      '',
      name: 'mail',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get attivo {
    return Intl.message(
      '',
      name: 'attivo',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get elimina {
    return Intl.message(
      '',
      name: 'elimina',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get conferma_password {
    return Intl.message(
      '',
      name: 'conferma_password',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get tipo_utente {
    return Intl.message(
      '',
      name: 'tipo_utente',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get responsabile_magazzino {
    return Intl.message(
      '',
      name: 'responsabile_magazzino',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get operatore_magazzino {
    return Intl.message(
      '',
      name: 'operatore_magazzino',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get admin {
    return Intl.message(
      '',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get modifica {
    return Intl.message(
      '',
      name: 'modifica',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get elimina_celle {
    return Intl.message(
      '',
      name: 'elimina_celle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get azienda {
    return Intl.message(
      '',
      name: 'azienda',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get parametri_generali {
    return Intl.message(
      '',
      name: 'parametri_generali',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get permetti_alloca_sfuso_su_celle {
    return Intl.message(
      '',
      name: 'permetti_alloca_sfuso_su_celle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get utilizza_etichette_udc_esterne {
    return Intl.message(
      '',
      name: 'utilizza_etichette_udc_esterne',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get accetta_articoli_non_presenti_in_lista {
    return Intl.message(
      '',
      name: 'accetta_articoli_non_presenti_in_lista',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get permetti_prelievo_senza_assegnazione {
    return Intl.message(
      '',
      name: 'permetti_prelievo_senza_assegnazione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get gestione_udc {
    return Intl.message(
      '',
      name: 'gestione_udc',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get anagrafica_udc {
    return Intl.message(
      '',
      name: 'anagrafica_udc',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get generazione_udc {
    return Intl.message(
      '',
      name: 'generazione_udc',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get tipo_udc {
    return Intl.message(
      '',
      name: 'tipo_udc',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get genera_udc {
    return Intl.message(
      '',
      name: 'genera_udc',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get stampa_automatica {
    return Intl.message(
      '',
      name: 'stampa_automatica',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get titolo_login {
    return Intl.message(
      '',
      name: 'titolo_login',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get gestione_stampe {
    return Intl.message(
      '',
      name: 'gestione_stampe',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get stampanti {
    return Intl.message(
      '',
      name: 'stampanti',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get stampe {
    return Intl.message(
      '',
      name: 'stampe',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get nuova_stampante {
    return Intl.message(
      '',
      name: 'nuova_stampante',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get id {
    return Intl.message(
      '',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get stampa_etichette {
    return Intl.message(
      '',
      name: 'stampa_etichette',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get crea_pdf_etichette {
    return Intl.message(
      '',
      name: 'crea_pdf_etichette',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get parametri_stampa {
    return Intl.message(
      '',
      name: 'parametri_stampa',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get modifica_stampante {
    return Intl.message(
      '',
      name: 'modifica_stampante',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get defaul {
    return Intl.message(
      '',
      name: 'defaul',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get copie {
    return Intl.message(
      '',
      name: 'copie',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get stampante {
    return Intl.message(
      '',
      name: 'stampante',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get periodo_num_qta_movimenti {
    return Intl.message(
      '',
      name: 'periodo_num_qta_movimenti',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get anno {
    return Intl.message(
      '',
      name: 'anno',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get trimestre {
    return Intl.message(
      '',
      name: 'trimestre',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get mese {
    return Intl.message(
      '',
      name: 'mese',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get settimana {
    return Intl.message(
      '',
      name: 'settimana',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get giorno {
    return Intl.message(
      '',
      name: 'giorno',
      desc: '',
      args: [],
    );
  }

  /// `test`
  String get test {
    return Intl.message(
      'test',
      name: 'test',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_conferma_cancellazione {
    return Intl.message(
      '',
      name: 'msg_conferma_cancellazione',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_conferma_salvataggio {
    return Intl.message(
      '',
      name: 'msg_conferma_salvataggio',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_url_server {
    return Intl.message(
      '',
      name: 'msg_url_server',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_utente_password_errati {
    return Intl.message(
      '',
      name: 'msg_utente_password_errati',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_utente_disconnesso {
    return Intl.message(
      '',
      name: 'msg_utente_disconnesso',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_campo_vuoto {
    return Intl.message(
      '',
      name: 'msg_campo_vuoto',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_selezionare_magazzino {
    return Intl.message(
      '',
      name: 'msg_selezionare_magazzino',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_necessaria_anteprima_prima_di_creazione_celle {
    return Intl.message(
      '',
      name: 'msg_necessaria_anteprima_prima_di_creazione_celle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_conferma_creazione_celle {
    return Intl.message(
      '',
      name: 'msg_conferma_creazione_celle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_creazione_celle_completata {
    return Intl.message(
      '',
      name: 'msg_creazione_celle_completata',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_mail_non_valida {
    return Intl.message(
      '',
      name: 'msg_mail_non_valida',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_conferm_mail_non_corrisponde {
    return Intl.message(
      '',
      name: 'msg_conferm_mail_non_corrisponde',
      desc: '',
      args: [],
    );
  }

  /// `{len}`
  String msg_lunghezza_password_minima(Object len) {
    return Intl.message(
      '$len',
      name: 'msg_lunghezza_password_minima',
      desc: '',
      args: [len],
    );
  }

  /// ``
  String get msg_salvataggio_eseguito {
    return Intl.message(
      '',
      name: 'msg_salvataggio_eseguito',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_elemento_non_trovato {
    return Intl.message(
      '',
      name: 'msg_elemento_non_trovato',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_selezionare_almeno_una_cella {
    return Intl.message(
      '',
      name: 'msg_selezionare_almeno_una_cella',
      desc: '',
      args: [],
    );
  }

  /// `{nome_elemento}`
  String msg_nessun_elemento_trovato(Object nome_elemento) {
    return Intl.message(
      '$nome_elemento',
      name: 'msg_nessun_elemento_trovato',
      desc: '',
      args: [nome_elemento],
    );
  }

  /// ``
  String get msg_qta_deve_essere_maggiore_zero {
    return Intl.message(
      '',
      name: 'msg_qta_deve_essere_maggiore_zero',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_selezionare_stampante {
    return Intl.message(
      '',
      name: 'msg_selezionare_stampante',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get msg_stampa_inviata_con_successo_alla_stampante {
    return Intl.message(
      '',
      name: 'msg_stampa_inviata_con_successo_alla_stampante',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get tooltip_utilizza_etichette_udc_esterne {
    return Intl.message(
      '',
      name: 'tooltip_utilizza_etichette_udc_esterne',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get tooltip_accetta_articoli_non_presenti_su_lista {
    return Intl.message(
      '',
      name: 'tooltip_accetta_articoli_non_presenti_su_lista',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
