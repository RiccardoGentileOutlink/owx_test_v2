import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ows_test_v2/autenticazione/models/utente_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/widgets/configurazione_server_dialog.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';

import 'package:package_info_plus/package_info_plus.dart';

class MenuLaterale extends StatelessWidget {
  final bool mostraHeader;
  const MenuLaterale({this.mostraHeader = true, super.key});

  @override
  Widget build(BuildContext context) {
    bool loggato = Utility.getUtenteProvider().isLoggato;
    TipoUtente tipoUtente = Utility.getUtenteProvider().tipoUtente;
    UtenteModel? utente = Utility.getUtenteProvider().utente;
    return Column(
      children: [
        Expanded(
          child: ListView(
            // Important: Remove any padding from the ListView.

            padding: mostraHeader
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: ValoriDefault.defaultPadding),
            children: [
              Visibility(
                visible: mostraHeader,
                child: SizedBox(
                  height: kIsWeb
                      ? ValoriDefault.defaultALtezzaDrawerWeb
                      : ValoriDefault.defaultALtezzaDrawerMobile,
                  child: DrawerHeader(
                    padding: const EdgeInsets.only(
                        left: ValoriDefault.defaultPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                    ),
                    child: loggato
                        ? Center(child: cardUtente(utente, context))
                        : Center(
                            child: FutureBuilder<PackageInfo>(
                              future: PackageInfo.fromPlatform(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!.appName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                  ),
                ),
              ),
              Visibility(
                visible: loggato && !mostraHeader,
                child: cardUtente(utente, context),
              ),

              //SEZIONE MAGAZZINO
              Visibility(
                visible: loggato,
                child: ExpansionTile(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  title: Text(
                    S.current.magazzino.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  initiallyExpanded: true,
                  children: [
                    VoceMenu(
                      container: this,
                      testo: S.current.gestione_udc.capitalize(),
                      icona: Icons.pallet,
                      link: '/web/gestione_udc',
                      visible: loggato && tipoUtente == TipoUtente.admin,
                    ),
                    VoceMenu(
                      container: this,
                      testo: S.current.mappatura_magazzino.capitalize(),
                      icona: Icons.warehouse,
                      link: '/web/mappatura_magazzino',
                      visible: loggato && tipoUtente == TipoUtente.admin,
                    ),
                    // VoceMenu(
                    //   container: this,
                    //   testo: 'Gestisci TTS',
                    //   icona: Icons.volume_up_sharp,
                    //   link: '/web/gestione_TTS',
                    //   visible:
                    //       loggato && kIsWeb && tipoUtente == TipoUtente.admin,
                    // ),
                    // VoceMenu(
                    //   container: this,
                    //   testo: 'Gestisci STT',
                    //   icona: Icons.volume_up_sharp,
                    //   link: '/web/gestione_STT',
                    //   visible:
                    //       loggato && kIsWeb && tipoUtente == TipoUtente.admin,
                    // ),
                    VoceMenu(
                      container: this,
                      testo: 'Bluetooth',
                      icona: Icons.volume_up_sharp,
                      link: '/web/test_bluetooth',
                      visible:
                          loggato && kIsWeb && tipoUtente == TipoUtente.admin,
                    ),
                  ],
                ),
              ),

              //SEZIONE CONFIGURAZIONI
              ExpansionTile(
                title: Text(
                  S.current.configurazioni.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                collapsedShape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                initiallyExpanded: true,
                children: [
                  VoceMenu(
                    container: this,
                    testo: S.current.gestione_utenti.capitalize(),
                    icona: Icons.person,
                    visible:
                        loggato && kIsWeb && tipoUtente == TipoUtente.admin,
                    link: '/web/gestione_utenti',
                  ),
                  VoceMenu(
                    container: this,
                    testo: S.current.parametri_generali.capitalize(),
                    icona: Icons.rule,
                    visible:
                        loggato && kIsWeb && tipoUtente == TipoUtente.admin,
                    link: '/web/parametri_generali',
                  ),
                  VoceMenu(
                    container: this,
                    testo: S.current.gestione_stampe.capitalize(),
                    icona: Icons.print,
                    visible: loggato &&
                        kIsWeb &&
                        tipoUtente == TipoUtente.admin, //vedere i permessi
                    link: '/web/gestione_stampe',
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
          child: ListTile(
            title: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${S.current.versione.capitalize()}: ${snapshot.data!.version}.${snapshot.data!.buildNumber}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey[600]),
                  );
                } else {
                  return Container();
                }
              },
            ),
            trailing: IconButton(
              onPressed: () {
                _chiudiMenuSeDrawer(context);
                ConfigurazioneServerDialog.mostraDialog(context);
              },
              icon: const Icon(Icons.settings),
              tooltip: S.current.configura_server,
            ),
          ),
        )
      ],
    );
  }

  void _chiudiMenuSeDrawer(BuildContext context) {
    if (mostraHeader) {
      Navigator.of(context).pop();
    }
  }

  void _vaiA(String route, String voceSelezionata, BuildContext context) {
    _chiudiMenuSeDrawer(context);
    GetIt.I<MenuLateraleStato>().selezionato = voceSelezionata;

    Navigator.of(context).pushReplacementNamed(route);
  }

  Widget cardUtente(UtenteModel? utente, BuildContext context) {
    Widget r = ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(utente != null ? utente.nomeECognome.toUpperCase() : ''),
      /*subtitle: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Text(
            DateFormat('EEEE, dd MMMM yyyy  |  hh:mm').format(DateTime.now()).capitalize(),
            style: Theme.of(context).textTheme.bodySmall,
          );
        },
      ),*/
      subtitle: Text(
        Utility.getUtenteProvider().azienda == null
            ? ''
            : Utility.getUtenteProvider().azienda!.ragione_sociale!,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
    if (mostraHeader) {
      return r;
    } else {
      return Card(
        color: Theme.of(context).secondaryHeaderColor,
        child: Padding(
            padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
            child: r),
      );
    }
  }
}

class VoceMenu extends StatelessWidget {
  final bool visible;
  final String testo;
  final IconData? icona;
  final String? link;
  final void Function()? onTapFunction;
  final MenuLaterale container;

  const VoceMenu(
      {this.visible = true,
      required this.testo,
      this.icona,
      this.link,
      this.onTapFunction,
      required this.container,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: ListTile(
          selected: GetIt.I<MenuLateraleStato>().selezionato == testo,
          leading: icona != null ? Icon(icona) : null,
          title: Text(testo),
          onTap: onTapFunction == null
              ? (() {
                  if (link != null) {
                    container._vaiA(link!, testo, context);
                  }
                })
              : onTapFunction!),
    );
  }
}

class MenuLateraleStato {
  String selezionato = "";
}
