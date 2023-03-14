import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/autenticazione/providers/utente_provider.dart';
import 'package:ows_test_v2/configurazione/models/stampa_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';
import 'package:ows_test_v2/generale/pages/generic_page.dart';
import 'package:ows_test_v2/generale/widgets/parametri_stampa_dialog.dart';
import 'package:ows_test_v2/generale/widgets/personal_pluto_grid.dart';
import 'package:ows_test_v2/generale/widgets/personal_tab.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/magazzino/models/tipo_udc_model.dart';
import 'package:ows_test_v2/magazzino/models/udc_model.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:ows_test_v2/web/magazzino/models/params/genera_udc_model.dart';
import 'package:ows_test_v2/web/magazzino/models/params/stampa_etichette_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class GestioneUdcPage extends StatefulWidget {
  const GestioneUdcPage({super.key});

  @override
  State<GestioneUdcPage> createState() => _GestioneUdcPageState();
}

class _GestioneUdcPageState extends State<GestioneUdcPage>
    with SingleTickerProviderStateMixin {
  int _tabSelezionata = 0;
  int? _tipoUdcSelezionato;
  bool _stampaAutomatica = true;

  List<TipoUdcModel>? listaTipi;
  List<DropdownMenuItem<int>> tipiUdc = <DropdownMenuItem<int>>[];
  final TextEditingController _controllerQuantita = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController _tabController;
  List<PlutoRow>? righe;
  List<UdcModel>? listaUdc;

  final List<PlutoColumn> columns = [];

  PlutoGridStateManager? _plutoGridStateManager;

  bool caricaUdc = true;
  @override
  void initState() {
    columns.addAll([
      PlutoColumn(
        title: S.current.codice.capitalize(),
        field: 'cod_udc',
        minWidth: 80,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.tipo_udc.capitalize(),
        field: 'cod_tipo_udc',
        minWidth: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.uscita_merce.capitalize(),
        field: 'uscita',
        width: 120,
        minWidth: 120,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.data_inserimento.capitalize(),
        field: 'data_ins',
        minWidth: 150,
        width: 150,
        type: PlutoColumnType.date(format: 'dd/MM/yy'),
      ),
      PlutoColumn(
        title: '',
        field: 'sel',
        type: PlutoColumnType.text(defaultValue: ''),
        enableRowChecked: true,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableDropToResize: false,
        minWidth: 60,
        width: 60,
      )
    ]);
    _tabController = TabController(length: 2, vsync: this);
    Utility.getServerProvider()
        .getListData(ApiMagazzino.getTipoUdc, null, mostraProgress: false)
        .then((value) {
      if (value.errore == null) {
        listaTipi = value.listData!
            .map(
              (e) => TipoUdcModel.fromJson(e),
            )
            .toList();
        if (listaTipi!.isEmpty) {
          Utility.setErrore(context,
              S.current.msg_nessun_elemento_trovato(S.current.tipo_udc));
        } else {
          setState(() {
            tipiUdc.addAll(listaTipi!
                .map((e) => DropdownMenuItem(
                      value: e.id_tipo_udc,
                      child: Text("${e.cod_tipo_udc} - ${e.desc_tipo_udc}"),
                    ))
                .toList());
            _tipoUdcSelezionato = tipiUdc.first.value;
          });
        }
      } else {
        Utility.setErrore(context, value.errore!);
      }
    });

    super.initState();
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
                        if (value == 0) {
                          caricaUdc = true;
                        }
                      });
                    },
                    tabs: [
                      PersonalTab(S.current.anagrafica_udc),
                      PersonalTab(S.current.generazione_udc),
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _getWidgetAnagrafica(),
                    _getWidgetCreazione(),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget _getWidgetCreazione() {
    return Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.transparent),
                  DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value == 0) {
                        return S.current.msg_campo_vuoto;
                      }
                      return null;
                    },
                    items: tipiUdc,
                    isDense: true,
                    value: _tipoUdcSelezionato,
                    disabledHint: Text(S.current.caricamento),
                    decoration: InputDecoration(
                      labelText: S.of(context).tipo_udc.capitalize(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _tipoUdcSelezionato = value;
                      });
                    },
                  ),
                  const Divider(color: Colors.transparent),
                  IntrinsicWidth(
                    stepWidth: 100,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _controllerQuantita,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: S.of(context).quantita.capitalize(),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.transparent),
                  Row(
                    children: [
                      Checkbox(
                        value: _stampaAutomatica,
                        onChanged: (value) {
                          setState(() {
                            _stampaAutomatica = value!;
                          });
                        },
                      ),
                      Text(S.current.stampa_automatica.capitalize()),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget>? _getElementiAppBar() {
    if (_tabSelezionata == 0) {
      return <Widget>[
        TextButton(
            onPressed: () {
              _stampaAnagraficaUDC();
            },
            child: Text(S.current.stampa.capitalize())),
        TextButton(
            onPressed: () {
              _creaPdfEtichette();
            },
            child: Text(S.current.crea_pdf_etichette.capitalize()))
      ];
    }
    if (_tabSelezionata == 1) {
      return <Widget>[
        TextButton(
            onPressed: () {
              _generaUdc();
            },
            child: Text(S.current.genera_udc.capitalize()))
      ];
    }
    return null;
  }

  void _generaUdc() {
    if (_formKey.currentState!.validate()) {
      if (_controllerQuantita.text == "") {
        setState(() {
          _controllerQuantita.text = "0";
        });
      }
      int qta = int.parse(_controllerQuantita.text);
      if (qta == 0) {
        Utility.mostraErrorDialog(context, S.current.generazione_udc,
            S.current.msg_qta_deve_essere_maggiore_zero.capitalize());
      } else {
        Utility.mostraConfermaDialog(context, S.current.generazione_udc,
                S.current.msg_conferma_salvataggio.capitalize())
            .then((value) {
          if (value == true) {
            //qui
            if (_stampaAutomatica) {
              _generaUdcMessaggio();
              _eseguiStampaServer();
            } else {
              _generaUdcMessaggio();
            }
          }
        });
      }
    }
  }
  
  void _generaUdcMessaggio() {
    Utility.getServerProvider()
        .postData(
            ApiMagazzino.generaUdc,
            GeneraUdcModel(
              id_tipo_udc: _tipoUdcSelezionato!,
              quantita: int.parse(_controllerQuantita.text),
              stampa: _stampaAutomatica,
            ).toJson())
        .then((value) {
      if (value.errore == null) {
        Utility.mostraMessaggioSalvataggioEseguito(context);
        _tabController.animateTo(0);
        setState(() {
          _tabSelezionata = 0;
          caricaUdc = true;
        });
      } else {
        /*_tabController.animateTo(0);
                setState(() {
                  _tabSelezionata = 0;
                  caricaUdc = true;
                });*/
        Utility.setErrore(context, value.errore!);
      }
    });
  }

  Widget _getWidgetAnagrafica() {
    //uso statefulBuilder per ircaricare la lista ogni volta che cambio tab
    if (caricaUdc) {
      setState(() {
        caricaUdc = false;
      });

      _getUdc().then((value) {
        if (value.errore == null) {
          listaUdc = value.listData!.map((e) => UdcModel.fromJson(e)).toList();
          righe = listaUdc!
              .map((e) => PlutoRow(
                      key: ValueKey(
                        e.id_udc,
                      ),
                      cells: {
                        'cod_udc': PlutoCell(value: e.cod_udc),
                        'cod_tipo_udc': PlutoCell(
                            value: e.tipoUdc != null
                                ? "${e.tipoUdc!.cod_tipo_udc} - ${e.tipoUdc!.desc_tipo_udc}"
                                : ''),
                        'uscita': PlutoCell(
                            value: e.tipoUdc != null
                                ? e.tipoUdc!.uscita!
                                    ? S.current.si.capitalize()
                                    : S.current.no.capitalize()
                                : '-'),
                        'data_ins': PlutoCell(value: e.data_ins),
                        'sel': PlutoCell(value: ''),
                      }))
              .toList();
          if (_plutoGridStateManager != null) {
            _plutoGridStateManager!.removeAllRows();
            _plutoGridStateManager!.appendRows(righe!);
          }
          setState(() {});
        }
      });
    }

    if (righe == null) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
        child: PersonalPlutoGrid(
          autoSize: PlutoAutoSizeMode.none,
          colonne: columns,
          righe: righe ?? [],
          mostraFiltri: false,
          setOnRowChecked: (event) {
            if (event.isAll) {
              for (var riga in _plutoGridStateManager!.iterateAllRow) {
                riga.setChecked(event.isChecked);
              }
            }
          },
          pageSize: 50,
          setPlutoGridStateManager: (manager) {
            _plutoGridStateManager = manager;
          },
        ),
      );
    }
  }

  Future<ResponseModel> _getUdc() async {
    await Future.delayed(
        kTabScrollDuration); //aspetto la fine dell'animazione tab
    return Utility.getServerProvider().getListData(ApiMagazzino.getUdc, null);
  }

  void _creaPdfEtichette() {
    if (_plutoGridStateManager != null) {
      if (_plutoGridStateManager!.hasCheckedRow == false) {
        Utility.mostraAlertDialog(context, S.current.attenzione,
            S.current.msg_selezionare_almeno_una_cella);
      } else {
        Future<ResponseModel> pdfResponse = _eseguiStampaServer();
        pdfResponse.then((value) {
          if (value.errore != null) {
            //Utility.mostraErrorDialog(context, S.current.attenzione, value.errore!);
            Utility.setErrore(context, value.errore!);
          }
        });
      }
    }
  }

  void _stampaAnagraficaUDC() {
    int? stampanteDefault;

    if (_plutoGridStateManager != null) {
      if (_plutoGridStateManager!.hasCheckedRow == false) {
        Utility.mostraAlertDialog(context, S.current.attenzione,
            S.current.msg_selezionare_almeno_una_cella);
      } else {
        Utility.getServerProvider()
            .getListData(ApiConfigurazione.getStampe, null)
            .then((value) {
          if (value.errore == null) {
            if (value.listData != null) {
              value.listData!.map((e) {
                StampaModel stampaModel = StampaModel.fromJson(e);
                if (stampaModel.cod_stampa == StampaModel.stampaEtichettaUDC) {
                  stampanteDefault = stampaModel.id_stampante_def;
                }
              }).toList();
            }
            ParametriGeneraliStampaModel params =
                ParametriGeneraliStampaModel(id_stampante: stampanteDefault);
            ParametriStampaDialog.mostraDialog(context, params).then((value) {
              if (value != null) {
                _eseguiStampaServer(paramGenerali: value).then((value) {
                  if (value.errore != null) {
                    Utility.setErrore(context, value.errore!);
                  } else {
                    if (value.resultOk != null && value.resultOk!) {
                      Utility.mostraMessaggioSalvataggioEseguito(
                        context,
                        msg: S.current
                            .msg_stampa_inviata_con_successo_alla_stampante
                            .capitalize(),
                      );
                    }
                  }
                });
              }
            });
          } else {
            Utility.setErrore(context, value.errore!);
          }
        });

        // capire come controllare il tipo di etichetta associata
      }
    }
  }

  Future<ResponseModel> _eseguiStampaServer(
      {ParametriGeneraliStampaModel? paramGenerali}) async {
    List<int> listaStampaUDC = [];
    for (PlutoRow riga in _plutoGridStateManager!.iterateFilteredMainRowGroup) {
      if (riga.checked ?? false) {
        listaStampaUDC.add((riga.key as ValueKey).value);
      }
    }
    if (paramGenerali == null) {
      StampaEtichetteUDCModel param = StampaEtichetteUDCModel(
          idUDC: listaStampaUDC,
          parametriGeneraliStampa: ParametriGeneraliStampaModel());
      ResponseModel res = await Utility.getServerProvider()
          .downloadFilePost(ApiMagazzino.stampaEtichetteUDC, param.toJson());

      if (res.bytes != null) {
        final XFile file = XFile.fromData(res.bytes!, name: 'UDC.pdf');
        await file.saveTo('UDC.pdf');
      }
      return res;
    } else {
      StampaEtichetteUDCModel param = StampaEtichetteUDCModel(
          idUDC: listaStampaUDC, parametriGeneraliStampa: paramGenerali);
      ResponseModel res = await Utility.getServerProvider()
          .postData(ApiMagazzino.stampaEtichetteUDC, param.toJson());
      return res;
    }
  }
}
