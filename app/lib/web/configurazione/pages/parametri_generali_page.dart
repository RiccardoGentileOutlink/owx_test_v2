import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/configurazione/models/parametro_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';

import 'package:ows_test_v2/generale/pages/generic_page.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';

class ParametriGeneraliPage extends StatefulWidget {
  const ParametriGeneraliPage({super.key});

  @override
  State<ParametriGeneraliPage> createState() => _ParametriGeneraliPageState();
}

class _ParametriGeneraliPageState extends State<ParametriGeneraliPage> {
  final _formKey = GlobalKey<FormState>();

  late bool permettiAllocaSfusoSuCelle;
  late bool utilizzaEtichetteUDCEsterne;
  late bool accettaArticoliNonPresentiSuLista;
  late bool permettiPrelievoSenzaAssegnazione;
  late String periodoMovimentazioni;

  List<ParametroModel>? parametri;

  @override
  void initState() {
    permettiAllocaSfusoSuCelle = false;
    utilizzaEtichetteUDCEsterne = false;
    accettaArticoliNonPresentiSuLista = false;
    permettiPrelievoSenzaAssegnazione = true;
    periodoMovimentazioni = PeriodoMovimentazioni.anno;

    Future<ResponseModel> res = Utility.getServerProvider().getListData(ApiConfigurazione.getParametri, null);
    res.then((value) {
      if (value.errore == null) {
        if (value.listData != null) {
          setState(() {
            parametri = value.listData!.map((e) => ParametroModel.fromJson(e)).toList();
            /*parametri!.map((e) {
              if (e.cod_parametro == Parametro.accetta_articoli_no_lista) {
                accettaArticoliNonPresentiSuLista = e.valore == "1";
              }
              if (e.cod_parametro == Parametro.permetti_allocazione_sfus) {
                permettiAllocaSfusoSuCelle = e.valore == "1";
              }
              if (e.cod_parametro == Parametro.usa_etichette_udc_esterne) {
                utilizzaEtichetteUDCEsterne = e.valore == "1";
              }
              if (e.cod_parametro == Parametro.permetti_prelievo_senza_assegnazione) {
                permettiPrelievoSenzaAssegnazione = e.valore == "1";
              }
            }).toList();*/
            for (ParametroModel e in parametri!) {
              if (e.cod_parametro == Parametro.accetta_articoli_no_lista) {
                accettaArticoliNonPresentiSuLista = e.valore == "1";
              }
              if (e.cod_parametro == Parametro.permetti_allocazione_sfus) {
                permettiAllocaSfusoSuCelle = e.valore == "1";
              }
              if (e.cod_parametro == Parametro.usa_etichette_udc_esterne) {
                utilizzaEtichetteUDCEsterne = e.valore == "1";
              }
              if (e.cod_parametro == Parametro.permetti_prelievo_senza_assegnazione) {
                permettiPrelievoSenzaAssegnazione = e.valore == "1";
              }
              if (e.cod_parametro == Parametro.periodo_movimentazioni) {
                periodoMovimentazioni = e.valore ?? PeriodoMovimentazioni.anno;
              }
            }
          });
        } else {
          parametri = <ParametroModel>[];
          parametri!.add(ParametroModel(cod_parametro: Parametro.accetta_articoli_no_lista, valore: '0'));
          parametri!.add(ParametroModel(cod_parametro: Parametro.permetti_allocazione_sfus, valore: '0'));
          parametri!.add(ParametroModel(cod_parametro: Parametro.usa_etichette_udc_esterne, valore: '0'));
          parametri!.add(ParametroModel(cod_parametro: Parametro.permetti_prelievo_senza_assegnazione, valore: '1'));
          parametri!.add(ParametroModel(cod_parametro: Parametro.periodo_movimentazioni, valore: PeriodoMovimentazioni.anno));
          setState(() {});
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
      elementiAppBar: [
        TextButton(
            onPressed: () {
              _salva();
            },
            child: Text(S.current.salva.capitalize()))
      ],
      appBarTitle: S.current.parametri_generali,
      expand: false,
      pageBody: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width),
        child: Form(
          key: _formKey,
          child: Visibility(
            visible: parametri != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(ValoriDefault.defaultPadding * 2),
                  child: Text(
                    S.current.parametri_generali.toUpperCase(),
                  ),
                ),
                Expanded(
                  child: ListView(children: [
                    SwitchListTile(
                      title: Text(S.current.permetti_alloca_sfuso_su_celle.capitalize()),
                      value: permettiAllocaSfusoSuCelle,
                      onChanged: (value) {
                        setState(() {
                          permettiAllocaSfusoSuCelle = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: _getLabelConTooltip(
                          S.current.utilizza_etichette_udc_esterne.capitalize(), S.current.tooltip_utilizza_etichette_udc_esterne.capitalize()),
                      value: utilizzaEtichetteUDCEsterne,
                      onChanged: (value) {
                        setState(() {
                          utilizzaEtichetteUDCEsterne = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: _getLabelConTooltip(
                          S.current.accetta_articoli_non_presenti_in_lista.capitalize(), S.current.tooltip_accetta_articoli_non_presenti_su_lista.capitalize()),
                      value: accettaArticoliNonPresentiSuLista,
                      onChanged: (value) {
                        setState(() {
                          accettaArticoliNonPresentiSuLista = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(S.current.permetti_prelievo_senza_assegnazione.capitalize()),
                      value: permettiPrelievoSenzaAssegnazione,
                      onChanged: (value) {
                        setState(() {
                          permettiPrelievoSenzaAssegnazione = value;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(S.current.periodo_num_qta_movimenti.capitalize()),
                      trailing: IntrinsicWidth(
                        child: DropdownButtonFormField(
                          isDense: true,
                          value: periodoMovimentazioni,
                          items: [
                            DropdownMenuItem(
                              value: PeriodoMovimentazioni.anno,
                              child: Text(S.current.anno.capitalize()),
                            ),
                            DropdownMenuItem(
                              value: PeriodoMovimentazioni.trimestre,
                              child: Text(S.current.trimestre.capitalize()),
                            ),
                            DropdownMenuItem(
                              value: PeriodoMovimentazioni.mese,
                              child: Text(S.current.mese.capitalize()),
                            ),
                            DropdownMenuItem(
                              value: PeriodoMovimentazioni.settimana,
                              child: Text(S.current.settimana.capitalize()),
                            ),
                            DropdownMenuItem(
                              value: PeriodoMovimentazioni.giorno,
                              child: Text(S.current.giorno.capitalize()),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              periodoMovimentazioni = value!;
                            });
                          },
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLabelConTooltip(String label, String tooltip) {
    return Wrap(direction: Axis.horizontal, children: [
      Text(label),
      Padding(
        padding: const EdgeInsets.only(left: ValoriDefault.defaultPadding),
        child: Tooltip(
          message: tooltip,
          child: const Icon(
            Icons.info,
            size: ValoriDefault.defaultAltezzaIconaInfo,
          ),
        ),
      )
    ]);
  }

  void _salva() {
    List<ParametroModel> parametriDaSalvare = <ParametroModel>[];
    parametriDaSalvare.add(ParametroModel(
        cod_parametro: Parametro.accetta_articoli_no_lista,
        desc_parametro: S.current.accetta_articoli_non_presenti_in_lista,
        valore: accettaArticoliNonPresentiSuLista ? '1' : '0'));
    parametriDaSalvare.add(ParametroModel(
        cod_parametro: Parametro.permetti_allocazione_sfus,
        desc_parametro: S.current.permetti_alloca_sfuso_su_celle,
        valore: permettiAllocaSfusoSuCelle ? '1' : '0'));
    parametriDaSalvare.add(ParametroModel(
        cod_parametro: Parametro.permetti_prelievo_senza_assegnazione,
        desc_parametro: S.current.permetti_prelievo_senza_assegnazione,
        valore: permettiPrelievoSenzaAssegnazione ? '1' : '0'));
    parametriDaSalvare.add(ParametroModel(
        cod_parametro: Parametro.usa_etichette_udc_esterne,
        desc_parametro: S.current.utilizza_etichette_udc_esterne,
        valore: utilizzaEtichetteUDCEsterne ? '1' : '0'));
    parametriDaSalvare.add(
        ParametroModel(cod_parametro: Parametro.periodo_movimentazioni, desc_parametro: S.current.periodo_num_qta_movimenti, valore: periodoMovimentazioni));
    Future<ResponseModel> res = Utility.getServerProvider().postListData(ApiConfigurazione.salvaParametri, parametriDaSalvare);
    res.then((value) {
      if (value.errore == null) {
        Utility.mostraMessaggioSalvataggioEseguito(context);
      } else {
        Utility.setErrore(context, value.errore!);
      }
    });
  }
}
