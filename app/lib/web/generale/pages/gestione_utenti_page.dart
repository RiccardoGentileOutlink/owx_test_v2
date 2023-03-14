import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/autenticazione/models/utente_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';
import 'package:ows_test_v2/generale/pages/generic_page.dart';
import 'package:ows_test_v2/generale/widgets/personal_pluto_grid.dart';
import 'package:ows_test_v2/generale/widgets/pulsanti_azioni_tabella.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:ows_test_v2/web/generale/pages/nuovo_utente_pop.dart';
import 'package:pluto_grid/pluto_grid.dart';

class GestioneUtentiPage extends StatefulWidget {
  const GestioneUtentiPage({super.key});

  @override
  State<GestioneUtentiPage> createState() => _GestioneUtentiPageState();
}

class _GestioneUtentiPageState extends State<GestioneUtentiPage> {
  Future<ResponseModel>? _futureLoadUtenti;
  late List<PlutoColumn> _colonne;
  late List<PlutoRow> _righe;

  PlutoGridStateManager? _plutoStateManager;

  @override
  void initState() {
    super.initState();
    _colonne = [
      PlutoColumn(
        hide: true,
        title: S.current.id.capitalize(),
        field: 'id_utente',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: S.current.nome.capitalize(),
        field: 'nome',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.cognome.capitalize(),
        field: 'cognome',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.mail.capitalize(),
        field: 'mail',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.attivo.capitalize(),
        field: 'attivo',
        type: PlutoColumnType.text(),
        width: 100,
        minWidth: 100,
      ),
      PlutoColumn(
        title: '',
        field: 'azioni',
        type: PlutoColumnType.text(),
        enableContextMenu: false,
        enableDropToResize: false,
        width: 100,
        minWidth: 100,
        renderer: (rendererContext) {
          return Row(
            children: [
              PulsanteModifica(
                azione: () {
                  _apriModifica(rendererContext.row.cells['id_utente']!.value);
                },
              ),
              PulsanteElimina(
                azione: () {
                  _elimina(rendererContext.row.cells['id_utente']!.value);
                },
              )
            ],
          );
        },
      ),
    ];
    _futureLoadUtenti = _getUtenti();
  }

  @override
  Widget build(BuildContext context) {
    return GenericPage(
        appBarTitle: S.current.gestione_utenti,
        elementiAppBar: [
          TextButton(
              onPressed: () {
                Future<bool?> res = Utility.mostraPageDialog(context,
                    pagina: const NuovoUtentePop(),
                    larghezza: NuovoUtentePop.larghezza,
                    altezza: NuovoUtentePop.altezza);

                res.then(
                  (value) {
                    if (value!) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(S.current.msg_salvataggio_eseguito
                              .capitalize())));
                      setState(() {
                        _futureLoadUtenti = _getUtenti();
                      });
                    }
                  },
                );
              },
              child: Text(S.current.nuovo_utente.capitalize())),
        ],
        expand: false,
        pageBody: FutureBuilder(
          future: _futureLoadUtenti,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double larghezza = 850;
              double larghezzaSchermo = MediaQuery.of(context).size.width;
              if (larghezzaSchermo > GenericPage.breakPoint) {
                larghezza = min(larghezzaSchermo - 400, 850);
              } else {
                larghezza = min(larghezzaSchermo, 850);
              }
              return Container(
                constraints: BoxConstraints(maxWidth: larghezza),
                child: Padding(
                  padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
                  child: PersonalPlutoGrid(
                    colonne: _colonne,
                    righe: _righe,
                    mostraFiltri: false,
                    setPlutoGridStateManager: (p0) {
                      _plutoStateManager = p0;
                    },
                    //autoSize: PlutoAutoSizeMode.none,
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Future<ResponseModel>? _getUtenti() {
    Future<ResponseModel> res = Utility.getServerProvider()
        .getListData(ApiAutenticazione.getUtenti, null);
    res.then(
      (value) {
        if (value.errore == null) {
          try {
            List<UtenteModel> celle =
                value.listData!.map((e) => UtenteModel.fromJson(e)).toList();

            _righe = celle
                .map((e) => PlutoRow(cells: {
                      'id_utente': PlutoCell(value: e.id_utente),
                      'nome': PlutoCell(value: e.nome),
                      'cognome': PlutoCell(value: e.cognome),
                      'mail': PlutoCell(value: e.mail),
                      'attivo': PlutoCell(value: e.attivo ? 'SI' : 'NO'),
                      'azioni': PlutoCell(value: ''),
                    }))
                .toList();
            if (_plutoStateManager != null) {
              _plutoStateManager!.removeAllRows();
              _plutoStateManager!.appendRows(_righe);
            }
          } on Error catch (err) {
            value.errore = err.toString();
            Utility.setErrore(context, value.errore!);
          }
        } else {
          _righe = [];
          Utility.setErrore(context, value.errore!);
        }
      },
    );

    return res;
  }

  void _apriModifica(value) {
    UtenteModel ut = UtenteModel(id_utente: value);
    Future<bool?> res = Utility.mostraPageDialog(context,
        pagina: NuovoUtentePop(
          utente: ut,
        ),
        larghezza: NuovoUtentePop.larghezza,
        altezza: NuovoUtentePop.altezza);

    res.then(
      (value) {
        if (value!) {
          Utility.mostraMessaggioSalvataggioEseguito(context);
          setState(() {
            _futureLoadUtenti = _getUtenti();
          });
        }
      },
    );
  }

  void _elimina(int idUtente) {
    Future<bool?> ok = Utility.mostraConfermaDialog(
        context,
        S.current.attenzione.capitalize(),
        S.current.msg_conferma_cancellazione);
    ok.then(
      (value) {
        if (value ?? false) {
          UtenteModel ut = UtenteModel(id_utente: idUtente);
          Future<ResponseModel> resElimina = Utility.getServerProvider()
              .deleteSingolo(ApiAutenticazione.eliminaUtente, ut);
          resElimina.then((value) {
            if (value.errore == null &&
                value.resultOk != null &&
                value.resultOk!) {
              setState(() {
                _futureLoadUtenti = _getUtenti();
              });
            } else {
              Utility.setErrore(context, value.errore!);
            }
          });
        }
      },
    );
  }
}
