import 'dart:async';
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/configurazione/models/stampa_model.dart';
import 'package:ows_test_v2/configurazione/models/stampante_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';
import 'package:ows_test_v2/generale/pages/generic_page.dart';
import 'package:ows_test_v2/generale/widgets/parametri_stampa_dialog.dart';
import 'package:ows_test_v2/generale/widgets/personal_pluto_grid.dart';
import 'package:ows_test_v2/generale/widgets/personal_tab.dart';
import 'package:ows_test_v2/generale/widgets/separatore_app_bar.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/magazzino/models/cella_model.dart';
import 'package:ows_test_v2/magazzino/models/magazzino_model.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:ows_test_v2/web/magazzino/models/params/mappatura_model.dart';
import 'package:ows_test_v2/web/magazzino/models/params/stampa_etichette_model.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;

class MappaturaMagazzinoPage extends StatefulWidget {
  const MappaturaMagazzinoPage({super.key, this.stampanteModel});

  static const int azioneAnteprima = 1;
  static const int azioneCrea = 2;
  static const int esportaCSV = 3;
  static const int creaPdfEtichette = 4;
  static const int eliminaCelle = 5;
  static const int stampaEtichette = 6;
  final StampanteModel? stampanteModel;

  @override
  State<MappaturaMagazzinoPage> createState() => _MappaturaMagazzinoPageState();
}

class _MappaturaMagazzinoPageState extends State<MappaturaMagazzinoPage> {
  int _tabSelezionata = 0;
  final List<Widget> _pulsantiAppAbar = <Widget>[];
  int azioneDaFare = 0;

  CreazioneMappatura? widgetCreazione;
  @override
  Widget build(BuildContext context) {
    _pulsantiAppAbar.clear();
    if (_tabSelezionata == 0) {
      _pulsantiAppAbar.add(TextButton(
          onPressed: () {
            setState(() {
              azioneDaFare = MappaturaMagazzinoPage.azioneAnteprima;
            });
          },
          child: Text(S.current.anteprima.capitalize())));
      _pulsantiAppAbar.add(const SeparatoreAppBar());
      _pulsantiAppAbar.add(TextButton(
          onPressed: () {
            setState(() {
              azioneDaFare = MappaturaMagazzinoPage.azioneCrea;
            });
          },
          child: Text(S.current.crea_celle.capitalize())));
    }
    if (_tabSelezionata == 1) {
      _pulsantiAppAbar.add(TextButton(
          onPressed: () {
            setState(() {
              azioneDaFare = MappaturaMagazzinoPage.stampaEtichette;
            });
          },
          child: Text(S.current.stampa_etichette.capitalize())));
      _pulsantiAppAbar.add(const SeparatoreAppBar());
      _pulsantiAppAbar.add(TextButton(
          onPressed: () {
            setState(() {
              azioneDaFare = MappaturaMagazzinoPage.creaPdfEtichette;
            });
          },
          child: Text(S.current.crea_pdf_etichette.capitalize())));
      _pulsantiAppAbar.add(const SeparatoreAppBar());
      _pulsantiAppAbar.add(TextButton(
          onPressed: () {
            setState(() {
              azioneDaFare = MappaturaMagazzinoPage.esportaCSV;
            });
          },
          child: Text(S.current.esporta_csv.capitalize())));
      _pulsantiAppAbar.add(const SeparatoreAppBar());

      _pulsantiAppAbar.add(TextButton(
          onPressed: () {
            setState(() {
              azioneDaFare = MappaturaMagazzinoPage.eliminaCelle;
            });
          },
          child: Text(S.current.elimina_celle.capitalize())));
    }
    return GenericPage(
      elementiAppBar: _pulsantiAppAbar,
      appBarTitle: S.current.mappatura_magazzino,
      pageBody: Padding(
        padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicWidth(
                child: TabBar(
                    onTap: (value) {
                      setState(() {
                        _tabSelezionata = value;
                      });
                    },
                    tabs: [
                      PersonalTab(S.current.creazione),
                      PersonalTab(S.current.anagrafica_celle.toUpperCase()),
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CreazioneMappatura(
                        azione: azioneDaFare,
                        notificaFineAzione: () {
                          setState(() {
                            azioneDaFare = 0;
                          });
                        }),
                    AnagraficaCelle(
                        azione: azioneDaFare,
                        notificaFineAzione: () {
                          setState(() {
                            azioneDaFare = 0;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// #region Creazione Mappatura
class CreazioneMappatura extends StatefulWidget {
  final int azione;
  final VoidCallback notificaFineAzione;
  const CreazioneMappatura(
      {this.azione = 0, required this.notificaFineAzione, super.key});

  @override
  State<CreazioneMappatura> createState() => _CreazioneMappaturaState();
}

class _CreazioneMappaturaState extends State<CreazioneMappatura>
    with AutomaticKeepAliveClientMixin<CreazioneMappatura> {
  int? _magazzinoSelezionato;
  String? _codiceMagazzinoSelezionato;
  List<DropdownMenuItem<int>> magazzini = <DropdownMenuItem<int>>[];
  List<MagazzinoModel> listaMagazzini = <MagazzinoModel>[];
  final _formKey = GlobalKey<FormState>();
  ComponenteMappaturaModel modelloMagazzino =
      ComponenteMappaturaModel(elemento: 'MAGAZZINO');
  ComponenteMappaturaModel modelloZona =
      ComponenteMappaturaModel(elemento: 'ZONA');
  ComponenteMappaturaModel modelloCorridoio =
      ComponenteMappaturaModel(elemento: 'CORRIDOIO');
  ComponenteMappaturaModel modelloMontante =
      ComponenteMappaturaModel(elemento: 'MONTANTE');
  ComponenteMappaturaModel modelloPiano =
      ComponenteMappaturaModel(elemento: 'PIANO');
  ComponenteMappaturaModel modelloCella =
      ComponenteMappaturaModel(elemento: 'CELLA');

  List<RigaAnteprimaMappaturaModel>? righeAnteprima;
  String? serializedCodes;

  int _righePerPagina = 50;
  bool _autoPageRows = true;

  final PaginatorController _paginatorController = PaginatorController();

  @override
  void initState() {
    Utility.getServerProvider()
        .getListData(ApiMagazzino.getMagazzini, null, mostraProgress: false)
        .then(
      (value) {
        if (value.errore == null) {
          try {
            for (var element in value.listData!) {
              MagazzinoModel mag = MagazzinoModel.fromJson(element);
              listaMagazzini.add(mag);
              magazzini.add(DropdownMenuItem<int>(
                value: mag.id_magazzino,
                child: Text(mag.descrizioneConCodice),
              ));
            }
          } on Error catch (err) {
            Utility.setErrore(context, err.toString(),
                stack: err.stackTrace.toString());
          }
        } else {
          Utility.setErrore(context, value.errore!);
        }
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    setState(() {
      _autoPageRows = MediaQuery.of(context).size.width < 600;
    });
    Widget widgetMappatura = Padding(
      padding: const EdgeInsets.all(ValoriDefault.defaultPadding)
          .copyWith(top: ValoriDefault.defaultPadding * 2),
      child: Form(
        key: _formKey,
        child: MediaQuery.of(context).size.width > 600
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _creaWidgetCreazione(),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.5,
                      height: double.infinity,
                      margin: const EdgeInsets.only(
                          left: ValoriDefault.defaultPadding,
                          right: ValoriDefault.defaultPadding),
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _creaWidgetAnteprima(),
                      ),
                    ),
                  ])
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._creaWidgetCreazione(),
                    SizedBox(
                      height: righeAnteprima == null
                          ? 100
                          : 100 +
                              (_righePerPagina + 2) * kMinInteractiveDimension,
                      //height: righeAnteprima == null ? 100 : 100 + 52 * kMinInteractiveDimension,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: ValoriDefault.defaultPadding * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _creaWidgetAnteprima(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );

    if (widget.azione == MappaturaMagazzinoPage.azioneAnteprima) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _anteprimaMappatura();
      });
    }
    if (widget.azione == MappaturaMagazzinoPage.azioneCrea) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _creaMappatura();
      });
    }
    return widgetMappatura;
  }

  @override
  bool get wantKeepAlive => true;

  void _anteprimaMappatura() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MappaturaModel mappatura =
          MappaturaModel(elementi: <ComponenteMappaturaModel>[]);
      mappatura.elementi.add(modelloMagazzino);
      mappatura.elementi.add(modelloZona);
      mappatura.elementi.add(modelloCorridoio);
      mappatura.elementi.add(modelloMontante);
      mappatura.elementi.add(modelloPiano);
      mappatura.elementi.add(modelloCella);

      // Utility.mostraProgress(context);
      Utility.getServerProvider()
          .postData(ApiMagazzino.anteprimaMappatura, mappatura.toJson())
          .then(
        (value) {
          //widget.notificaFineAzione();
          if (value.errore == null) {
            ResponseAnteprimaModel responseAnteprima =
                ResponseAnteprimaModel.fromJson(value.data!);
            if (responseAnteprima.error != null) {
              Utility.mostraAlertDialog(
                  context, S.current.attenzione, responseAnteprima.error!);
            } else {
              _righePerPagina =
                  responseAnteprima.listaRigheAnteprima.length > 50
                      ? 50
                      : responseAnteprima.listaRigheAnteprima.length;
              if (_paginatorController.isAttached) {
                _paginatorController.setRowsPerPage(_righePerPagina);
              }

              setState(() {
                _righePerPagina =
                    responseAnteprima.listaRigheAnteprima.length > 50
                        ? 50
                        : responseAnteprima.listaRigheAnteprima.length;
                righeAnteprima = responseAnteprima.listaRigheAnteprima;
                serializedCodes = responseAnteprima.serializedResult;
              });
            }
          } else {
            Utility.setErrore(context, value.errore!);
          }
        },
      );
    }
    widget.notificaFineAzione();
  }

  void _creaMappatura() {
    if (serializedCodes != null) {
      MappaturaModel mappatura =
          MappaturaModel(elementi: <ComponenteMappaturaModel>[]);
      mappatura.elementi.add(modelloMagazzino);
      mappatura.elementi.add(modelloZona);
      mappatura.elementi.add(modelloCorridoio);
      mappatura.elementi.add(modelloMontante);
      mappatura.elementi.add(modelloPiano);
      mappatura.elementi.add(modelloCella);
      Utility.mostraConfermaDialog(context, S.current.crea_celle,
              S.current.msg_conferma_creazione_celle)
          .then((conferma) {
        conferma ??= false;
        if (conferma) {
          // Utility.mostraProgress(context);
          Utility.getServerProvider().postData(
              ApiMagazzino.creaMappatura, <String, dynamic>{
            'jsonCodes': serializedCodes,
            'jsonDescs': jsonEncode(mappatura)
          }).then(
            (value) {
              //widget.notificaFineAzione();
              if (value.errore == null) {
                ResponseAnteprimaModel responseAnteprima =
                    ResponseAnteprimaModel.fromJson(value.data!);
                if (responseAnteprima.error != null) {
                  Utility.mostraAlertDialog(
                      context, S.current.attenzione, responseAnteprima.error!);
                } else {
                  Utility.mostraInfoDialog(
                      context, '', S.current.msg_creazione_celle_completata);
                  setState(() {
                    righeAnteprima = null;
                    serializedCodes = null;
                  });
                }
              } else {
                Utility.setErrore(context, value.errore!);
              }
            },
          );
        }
      });
    } else {
      Utility.mostraAlertDialog(context, S.current.attenzione.capitalize(),
          S.current.msg_necessaria_anteprima_prima_di_creazione_celle);
    }
    widget.notificaFineAzione();
  }

  List<Widget> _creaWidgetCreazione() {
    return [
      IntrinsicWidth(
        child: DropdownButtonFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value == 0) {
              return S.current.msg_selezionare_magazzino;
            }
            return null;
          },
          items: magazzini,
          isDense: true,
          value: _magazzinoSelezionato,
          disabledHint: Text(S.current.caricamento),
          decoration: InputDecoration(
            labelText: S.of(context).magazzino.capitalize(),
            isDense: true,
          ),
          onChanged: (value) {
            setState(() {
              _magazzinoSelezionato = value;
              _codiceMagazzinoSelezionato = listaMagazzini
                  .firstWhere((element) => element.id_magazzino == value)
                  .cod_magazzino;
              modelloMagazzino.codice = _codiceMagazzinoSelezionato ?? '';
            });
          },
        ),
      ),
      const Divider(),
      CampiMappatura(S.current.zona.toUpperCase(), (campo, valore) {
        if (campo == "Codice") {
          modelloZona.codice = valore;
        }
        if (campo == "Quantita") {
          modelloZona.quantita = valore;
        }
        if (campo == "Descrizione") {
          modelloZona.descrizione = valore;
        }
      }),
      const Divider(),
      CampiMappatura(S.current.corridoio.toUpperCase(), (campo, valore) {
        if (campo == "Codice") {
          modelloCorridoio.codice = valore;
        }
        if (campo == "Quantita") {
          modelloCorridoio.quantita = valore;
        }
        if (campo == "Descrizione") {
          modelloCorridoio.descrizione = valore;
        }
      }),
      const Divider(),
      CampiMappatura(S.current.montante.toUpperCase(), (campo, valore) {
        if (campo == "Codice") {
          modelloMontante.codice = valore;
        }
        if (campo == "Quantita") {
          modelloMontante.quantita = valore;
        }
        if (campo == "Descrizione") {
          modelloMontante.descrizione = valore;
        }
      }),
      const Divider(),
      CampiMappatura(S.current.piano.toUpperCase(), (campo, valore) {
        if (campo == "Codice") {
          modelloPiano.codice = valore;
        }
        if (campo == "Quantita") {
          modelloPiano.quantita = valore;
        }
        if (campo == "Descrizione") {
          modelloPiano.descrizione = valore;
        }
      }),
      const Divider(),
      CampiMappatura(S.current.cella.toUpperCase(), (campo, valore) {
        if (campo == "Codice") {
          modelloCella.codice = valore;
        }
        if (campo == "Quantita") {
          modelloCella.quantita = valore;
        }
        if (campo == "Descrizione") {
          modelloCella.descrizione = valore;
        }
      }),
    ];
  }

  List<Widget> _creaWidgetAnteprima() {
    return [
      Text(S.current.anteprima_celle_in_creazione.toUpperCase()),
      Expanded(
        child: Visibility(
            visible: righeAnteprima != null,
            child: PaginatedDataTable2(
              controller: _paginatorController,
              autoRowsToHeight: _autoPageRows,
              minWidth: 600,
              columnSpacing: 18,
              renderEmptyRowsInTheEnd: false,
              fit: FlexFit.tight,
              showFirstLastButtons: true,
              rowsPerPage: _righePerPagina,
              columns: [
                DataColumn(label: Text(S.current.magazzino.toUpperCase())),
                DataColumn(label: Text(S.current.zona.toUpperCase())),
                DataColumn(label: Text(S.current.corridoio.toUpperCase())),
                DataColumn(label: Text(S.current.montante.toUpperCase())),
                DataColumn(label: Text(S.current.piano.toUpperCase())),
                DataColumn(label: Text(S.current.cella.toUpperCase())),
              ],
              source: RigheAnteprimaSource(
                List<DataRow>.generate(
                  righeAnteprima != null ? righeAnteprima!.length : 0,
                  (index) {
                    return DataRow(
                      cells: [
                        DataCell(Text(_codiceMagazzinoSelezionato!)),
                        DataCell(Text(righeAnteprima![index].zona!)),
                        DataCell(Text(righeAnteprima![index].corridoio!)),
                        DataCell(Text(righeAnteprima![index].montante!)),
                        DataCell(Text(righeAnteprima![index].piano!)),
                        DataCell(Text(righeAnteprima![index].cella!)),
                      ],
                    );
                  },
                ),
              ),
            )),
      )
    ];
  }
}

class RigheAnteprimaSource extends DataTableSource {
  List<DataRow> righe;

  RigheAnteprimaSource(this.righe);

  @override
  DataRow? getRow(int index) {
    return righe[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => righe.length;

  @override
  int get selectedRowCount => 0;
}

class CampiMappatura extends StatefulWidget {
  final String tipo;
  final Function(String, dynamic) onSave;

  const CampiMappatura(this.tipo, this.onSave, {super.key});

  @override
  State<CampiMappatura> createState() => _CampiMappaturaState();
}

class _CampiMappaturaState extends State<CampiMappatura> {
  final TextEditingController _controllerCodice = TextEditingController();
  final TextEditingController _controllerQuantita = TextEditingController();
  final TextEditingController _controllerDescrizione = TextEditingController();

  bool _qtaAbilitata = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: ValoriDefault.defaultPadding),
          child: Text(
            widget.tipo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "";
                  }
                  return null;
                },
                maxLength: 3,
                onSaved: (newValue) {
                  widget.onSave('Codice', newValue);
                },
                onChanged: (value) {
                  if (value.isNotEmpty &&
                      int.tryParse(value.substring(value.length - 1)) == null) {
                    setState(() {
                      _qtaAbilitata = false;
                      _controllerQuantita.text = "1";
                    });
                  } else {
                    setState(() {
                      _qtaAbilitata = true;
                    });
                  }
                },
                controller: _controllerCodice,
                decoration: InputDecoration(
                  labelText: S.of(context).codice.capitalize(),
                ),
              ),
            ),
            const SizedBox(
              width: ValoriDefault.defaultPadding,
            ),
            SizedBox(
              width: 80,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  widget.onSave(
                      'Quantita',
                      int.tryParse(newValue!) == null
                          ? 0
                          : int.parse(newValue));
                },
                maxLength: 4,
                enabled: _qtaAbilitata,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _controllerQuantita,
                decoration: InputDecoration(
                  counterText: "",
                  labelText: S.of(context).quantita.capitalize(),
                ),
              ),
            ),
            const SizedBox(
              width: ValoriDefault.defaultPadding,
            ),
            Expanded(
              child: TextFormField(
                onSaved: (newValue) {
                  widget.onSave('Descrizione', newValue);
                },
                expands: false,
                maxLength: 100,
                controller: _controllerDescrizione,
                decoration: InputDecoration(
                  labelText: S.of(context).descrizione.capitalize(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

// #endregion

// #region Anagrafica Celle
class AnagraficaCelle extends StatefulWidget {
  final int azione;
  final VoidCallback notificaFineAzione;
  const AnagraficaCelle(
      {this.azione = 0, required this.notificaFineAzione, super.key});

  @override
  State<AnagraficaCelle> createState() => _AnagraficaCelleState();
}

class _AnagraficaCelleState extends State<AnagraficaCelle> {
  final List<PlutoColumn> columns = [];

  List<PlutoRow>? righe;

  Future<ResponseModel>? _futureLoadMappatura;

  PlutoGridStateManager? _plutoGridStateManager;

  bool completato = false;

  @override
  void initState() {
    super.initState();
    //_futureLoadMappatura = _getCelle();

    columns.addAll([
      PlutoColumn(
        title: S.current.magazzino.capitalize(),
        field: 'cod_magazzino',
        minWidth: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.zona.capitalize(),
        field: 'cod_zona',
        minWidth: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.corridoio.capitalize(),
        field: 'cod_corridoio',
        minWidth: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.montante.capitalize(),
        field: 'cod_montante',
        minWidth: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.piano.capitalize(),
        field: 'cod_piano',
        minWidth: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.cella.capitalize(),
        field: 'cod_cella',
        minWidth: 90,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: S.current.codice.capitalize(),
        field: 'cod',
        minWidth: 90,
        type: PlutoColumnType.text(),
        /*renderer: (rendererContext) {
          return Tooltip(
            message: rendererContext.cell.value,
            child: Text(
              rendererContext.cell.value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },*/
      ),
      PlutoColumn(
        title: S.current.data_inserimento.capitalize(),
        field: 'data_ins',
        minWidth: 90,
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

    _futureLoadMappatura = _getCelle();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.azione == MappaturaMagazzinoPage.esportaCSV) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _esportaCSV();
      });
      Future.delayed(Duration.zero)
          .then((value) => widget.notificaFineAzione());
    }
    if (widget.azione == MappaturaMagazzinoPage.stampaEtichette) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _stampaEtichette();
      });
      Future.delayed(Duration.zero)
          .then((value) => widget.notificaFineAzione());
    }
    if (widget.azione == MappaturaMagazzinoPage.creaPdfEtichette) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _creaPdfEtichette();
      });
      Future.delayed(Duration.zero)
          .then((value) => widget.notificaFineAzione());
    }
    if (widget.azione == MappaturaMagazzinoPage.eliminaCelle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _eliminaCelle();
      });
      Future.delayed(Duration.zero)
          .then((value) => widget.notificaFineAzione());
    }
    if (!completato) {
      // Future.delayed(Duration.zero).then((value) => Utility.mostraProgress(context));
    }

    return FutureBuilder(
      future: _futureLoadMappatura,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ResponseModel value = snapshot.data!;
          if (value.errore == null) {
            return Padding(
              padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
              child: PersonalPlutoGrid(
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
          } else {
            Utility.setErrore(context, value.errore!);
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Future<ResponseModel> _getCelle() async {
    await Future.delayed(
        kTabScrollDuration); //aspetto la fine dell'animazione tab
    ResponseModel res = await Utility.getServerProvider()
        .getListData(ApiMagazzino.getCelle, null);
    setState(() {
      completato = true;
    });
    if (res.errore == null) {
      try {
        List<CellaModel> celle =
            res.listData!.map((e) => CellaModel.fromJson(e)).toList();
        //PER TEST solo i primi 100 record
        //List<CellaModel> celle = res.listData!.getRange(0, 100).map((e) => CellaModel.fromJson(e)).toList();
        righe = celle
            .map((e) => PlutoRow(
                    key: ValueKey(
                      e.id_cella.toString(),
                    ),
                    cells: {
                      'cod_magazzino': PlutoCell(
                          value: e.piano?.montante?.corridoio?.zona?.magazzino
                              ?.cod_magazzino),
                      'cod_zona': PlutoCell(
                          value: e.piano?.montante?.corridoio?.zona?.cod_zona),
                      'cod_corridoio': PlutoCell(
                          value: e.piano?.montante?.corridoio?.cod_corridoio),
                      'cod_montante':
                          PlutoCell(value: e.piano?.montante?.cod_montante),
                      'cod_piano': PlutoCell(value: e.piano?.cod_piano),
                      'cod_cella': PlutoCell(value: e.cod_cella),
                      'cod': PlutoCell(value: e.cod),
                      'data_ins': PlutoCell(value: e.data_ins),
                      'sel': PlutoCell(value: ''),
                    }))
            .toList();
      } on Error catch (err) {
        res.errore = err.toString();
      }
    }

    return res;
  }

  void _esportaCSV() async {
    if (_plutoGridStateManager != null) {
      String nomeFile = "lista_celle.csv";
      Uint8List exported = const Utf8Encoder().convert(
          pluto_grid_export.PlutoGridExport.exportCSV(_plutoGridStateManager!));
      final XFile file = XFile.fromData(exported, name: nomeFile);
      await file.saveTo(nomeFile);
    }
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

  void _stampaEtichette() {
    int? stampanteDefault;
    //aggiungere la stampante default

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
                if (stampaModel.cod_stampa ==
                    StampaModel.stampaEtichettaCella) {
                    stampanteDefault = stampaModel.id_stampante_def;
                }
              }).toList();
            }
            ParametriGeneraliStampaModel params = ParametriGeneraliStampaModel(
                id_stampante: stampanteDefault); //controllare ETCELLA
            ParametriStampaDialog.mostraDialog(context, params).then((value) {
              if (value != null) {
                _eseguiStampaServer(paramGenerali: value).then((value) {
                  if (value.errore != null) {
                    //Utility.mostraErrorDialog(context, S.current.attenzione, value.errore!);
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
    List<String> listaCelle = [];
    for (PlutoRow riga in _plutoGridStateManager!.iterateFilteredMainRowGroup) {
      if (riga.checked ?? false) {
        listaCelle.add((riga.key as ValueKey).value);
      }
    }
    if (paramGenerali == null) {
      StampaEtichetteCelleModel param = StampaEtichetteCelleModel(
          idCelle: listaCelle,
          parametriGeneraliStampa: ParametriGeneraliStampaModel());
      ResponseModel res = await Utility.getServerProvider()
          .downloadFilePost(ApiMagazzino.stampaEtichetteCelle, param.toJson());

      if (res.bytes != null) {
        final XFile file = XFile.fromData(res.bytes!, name: 'celle.pdf');
        await file.saveTo('celle.pdf');
      }
      return res;
    } else {
      StampaEtichetteCelleModel param = StampaEtichetteCelleModel(
          idCelle: listaCelle, parametriGeneraliStampa: paramGenerali);
      ResponseModel res = await Utility.getServerProvider()
          .postData(ApiMagazzino.stampaEtichetteCelle, param.toJson());
      return res;
    }
  }

  void _eliminaCelle() {
    if (_plutoGridStateManager != null) {
      if (_plutoGridStateManager!.hasCheckedRow == false) {
        Utility.mostraAlertDialog(context, S.current.attenzione,
            S.current.msg_selezionare_almeno_una_cella);
      } else {
        Future<bool?> cancella = Utility.mostraConfermaDialog(
            context,
            S.current.elimina_celle.capitalize(),
            S.current.msg_conferma_cancellazione);
        cancella.then((value) {
          if (value != null && value) {
            List<CellaModel> listaCelle = [];
            for (PlutoRow riga
                in _plutoGridStateManager!.iterateFilteredMainRowGroup) {
              if (riga.checked ?? false) {
                String idCellaString = (riga.key as ValueKey).value;
                listaCelle.add(CellaModel(
                    id_cella: int.parse(idCellaString),
                    id_azienda: Utility.getIdAzienda()));
              }
            }
            Future<ResponseModel> res = Utility.getServerProvider()
                .delete(ApiMagazzino.eliminaCelle, listaCelle);
            res.then((value) {
              if (value.errore == null) {
                _getCelle().then((value) {
                  _plutoGridStateManager!.removeAllRows();
                  _plutoGridStateManager!.appendRows(righe!);
                });
              } else {
                Utility.setErrore(context, value.errore!);
              }
            });
          }
        });
      }
    }
  }

  /* void _esportaPDF() async {
    //VA IN ERRORE CON PIU di 20 pagine per ora commentiamo, eventualmente implementiamo l'export PDF lato server
    if (_plutoGridStateManager != null) {
      final themeData = pluto_grid_export.ThemeData.withFont(
        base: pluto_grid_export.Font.ttf(
          await rootBundle.load('fonts/open_sans/OpenSans-Regular.ttf'),
        ),
        bold: pluto_grid_export.Font.ttf(
          await rootBundle.load('fonts/open_sans/OpenSans-Bold.ttf'),
        ),
      );

      pluto_grid_export.PlutoGridDefaultPdfExport plutoGridPdfExport = pluto_grid_export.PlutoGridDefaultPdfExport(
        title: "lista celle",
        creator: "Pluto Grid Rocks!",
        format: pluto_grid_export.PdfPageFormat.a4.landscape,
        themeData: themeData,
      );
      await pluto_grid_export.Printing.sharePdf(bytes: await plutoGridPdfExport.export(_plutoGridStateManager!), filename: 'lista_celle.pdf');
    }
  }*/
} /* #endregion */

// #endregion
