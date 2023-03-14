import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/configurazione/models/stampa_model.dart';
import 'package:ows_test_v2/configurazione/models/stampante_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';

import 'package:ows_test_v2/generale/pages/generic_page.dart';
import 'package:ows_test_v2/generale/widgets/personal_pluto_grid.dart';
import 'package:ows_test_v2/generale/widgets/personal_tab.dart';
import 'package:ows_test_v2/generale/widgets/pulsanti_azioni_tabella.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:ows_test_v2/web/configurazione/pages/modifica_stampa_pop.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'nuova_stampante_pop.dart';

class GestioneStampePage extends StatefulWidget {
  const GestioneStampePage({super.key});

  @override
  State<GestioneStampePage> createState() => _GestioneStampePageState();
}

class _GestioneStampePageState extends State<GestioneStampePage>
    with SingleTickerProviderStateMixin {
  Future<ResponseModel>? _futureLoadStampanti;
  Future<ResponseModel>? _futureLoadStampe;

  int _tabSelezionata = 0;
  late TabController _tabController;
  late List<PlutoColumn> _colonne;
  late List<PlutoColumn> _colonneStampe;
  late List<PlutoRow> _righe;
  late List<PlutoRow> _righeStampe;
  PlutoGridStateManager? _plutoStateManager;
  PlutoGridStateManager? _plutoStateManagerStampe;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _colonne = [
      PlutoColumn(
        hide: true,
        title: S.current.id.capitalize(),
        field: 'id_stampante',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        hide: false,
        title: S.current.nome.capitalize(),
        field: 'nome_stampante',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        hide: false,
        title: S.current.descrizione.capitalize(),
        field: 'desc_stampante',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '',
        field: 'azioni',
        type: PlutoColumnType.text(),
        enableContextMenu: false,
        enableDropToResize: false,
        width: 60,
        minWidth: 100,
        renderer: (rendererContext) {
          return Row(
            children: [
              PulsanteModifica(
                azione: () {
                  _apriModifica(
                      rendererContext.row.cells['id_stampante']!.value);
                },
              ),
              PulsanteElimina(
                azione: () {
                  _elimina(rendererContext.row.cells['id_stampante']!.value);
                },
              )
            ],
          );
        },
      ),
    ];

    _futureLoadStampanti = _getStampanti();

    _colonneStampe = [
      PlutoColumn(
        hide: true,
        title: S.current.id.capitalize(),
        field: 'id_stampa',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        hide: false,
        title: S.current.codice.capitalize(),
        field: 'cod_stampa',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        hide: false,
        title: S.current.descrizione.capitalize(),
        field: 'desc_stampa',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        hide: false,
        title:
            '${S.current.stampante.capitalize()} ${S.current.defaul.capitalize()}',
        field: 'stampante_default',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '',
        field: 'azioni',
        type: PlutoColumnType.text(),
        enableContextMenu: false,
        enableDropToResize: false,
        width: 40,
        minWidth: 60,
        renderer: (rendererContext) {
          return Row(
            children: [
              PulsanteModifica(
                azione: () {
                  _apriModificaStampa(
                      rendererContext.row.cells['id_stampa']!.value);
                },
              ),
            ],
          );
        },
      ),
    ];
    _futureLoadStampe = _getStampe();
  }

  @override
  Widget build(BuildContext context) {
    return GenericPage(
      appBarTitle: S.current.gestione_udc,
      elementiAppBar: _getElementiAppBar(),
      pageBody: Padding(
        padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicWidth(
                child: TabBar(
                    controller: _tabController,
                    onTap: (value) {
                      setState(() {
                        _tabSelezionata = value;
                      });
                    },
                    tabs: [
                      PersonalTab(S.current.stampanti),
                      PersonalTab(S.current.stampe),
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //my function
                    _getWidgetStampanti(),
                    _getWidgetStampe(),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  List<Widget>? _getElementiAppBar() {
    if (_tabSelezionata == 0) {
      return <Widget>[
        TextButton(
            onPressed: () {
              Future<bool?> res = Utility.mostraPageDialog(
                context,
                pagina: const NuovaStampantePop(),
                larghezza: NuovaStampantePop.larghezza,
                altezza: NuovaStampantePop.altezza,
              );
              res.then((value) {
                if (value != null && value) {
                  _futureLoadStampanti = _getStampanti();
                  //_futureLoadStampe = _getStampe();
                }
              });
            },
            child: Text(S.current.nuova_stampante.capitalize())),
        TextButton(
            onPressed: () {
              
            },
            child: Text(S.current.test.capitalize()))
      ];
    }
    return null;
  }

  Widget _getWidgetStampanti() {
    return Scaffold(
      body: FutureBuilder(
        future: _futureLoadStampanti,
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
      ),
    );
  }

  Widget _getWidgetStampe() {
    return Scaffold(
      body: FutureBuilder(
        future: _futureLoadStampe,
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
                  colonne: _colonneStampe,
                  righe: _righeStampe,
                  mostraFiltri: false,
                  setPlutoGridStateManager: (p0) {
                    _plutoStateManagerStampe = p0;
                  },
                  //autoSize: PlutoAutoSizeMode.none,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<ResponseModel> _getStampanti() {
    Future<ResponseModel> res = Utility.getServerProvider()
        .getListData(ApiConfigurazione.getStampanti, null);
    res.then((value) {
      if (value.errore == null) {
        try {
          List<StampanteModel> row =
              value.listData!.map((e) => StampanteModel.fromJson(e)).toList();

          _righe = row
              .map((e) => PlutoRow(cells: {
                    'id_stampante': PlutoCell(value: e.id_stampante),
                    'nome_stampante': PlutoCell(value: e.nome_stampante),
                    'desc_stampante': PlutoCell(value: e.desc_stampante),
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
    });

    return res;
  }

  Future<ResponseModel> _getStampe() {
    Future<ResponseModel> res = Utility.getServerProvider()
        .getListData(ApiConfigurazione.getStampe, null);
    res.then((value) {
      if (value.errore == null) {
        try {
          List<StampaModel> row =
              value.listData!.map((e) => StampaModel.fromJson(e)).toList();

          _righeStampe = row
              .map((e) => PlutoRow(cells: {
                    'id_stampa': PlutoCell(value: e.id_stampa),
                    'cod_stampa': PlutoCell(value: e.cod_stampa),
                    'desc_stampa': PlutoCell(value: e.desc_stampa),
                    'stampante_default':
                        PlutoCell(value: e.stampante_def?.nome_stampante ?? ''),
                    'azioni': PlutoCell(value: ''),
                  }))
              .toList();
          if (_plutoStateManagerStampe != null) {
            _plutoStateManagerStampe!.removeAllRows();
            _plutoStateManagerStampe!.appendRows(_righeStampe);
          }
        } on Error catch (err) {
          value.errore = err.toString();
          Utility.setErrore(context, value.errore!);
        }
      } else {
        _righe = [];
        Utility.setErrore(context, value.errore!);
      }
    });
    return res;
  }

  //apro la mofica per le stampe
  _apriModifica(param) {
    StampanteModel stamp = StampanteModel(id_stampante: param);
    Future<bool?> res = Utility.mostraPageDialog(context,
        pagina: NuovaStampantePop(
          stampante: stamp,
        ),
        larghezza: NuovaStampantePop.larghezza,
        altezza: NuovaStampantePop.altezza);
    res.then(
      (value) {
        if (value!) {
          Utility.mostraMessaggioSalvataggioEseguito(context);
          setState(() {
            _futureLoadStampanti = _getStampanti();
          });
        }
      },
    );
  }

  //apro la modifica delle stampe
  _apriModificaStampa(param) {
    StampaModel stamp = StampaModel(id_stampa: param);
    Utility.mostraPageDialog(
      context,
      pagina: ModificaStampaPop(
        stampa: stamp,
      ),
      larghezza: ModificaStampaPop.larghezza,
      altezza: ModificaStampaPop.altezza,
    ).then(
      (value) {
        if (value!) {
          Utility.mostraMessaggioSalvataggioEseguito(context);
          setState(() {
            _futureLoadStampe = _getStampe();
          });
        }
      },
    );
  }

  _elimina(int idStampante) {
    Future<bool?> ok = Utility.mostraConfermaDialog(
        context,
        S.current.attenzione.capitalize(),
        S.current.msg_conferma_cancellazione);
    ok.then(
      (value) {
        if (value ?? false) {
          StampanteModel stamp = StampanteModel(id_stampante: idStampante);
          Future<ResponseModel> resElimina = Utility.getServerProvider()
              .deleteSingolo(ApiConfigurazione.eliminaStampante, stamp);
          resElimina.then((value) {
            if (value.errore == null &&
                value.resultOk != null &&
                value.resultOk!) {
              setState(() {
                _futureLoadStampanti = _getStampanti();
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
