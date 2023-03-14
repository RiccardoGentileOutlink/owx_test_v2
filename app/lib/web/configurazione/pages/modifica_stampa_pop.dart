// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/configurazione/models/stampa_model.dart';
import 'package:ows_test_v2/configurazione/models/stampante_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/pages/generic_page_popup.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';

class ModificaStampaPop extends StatefulWidget {
  const ModificaStampaPop({super.key, this.stampa});
  static double larghezza = 550;
  static double altezza = 200;
  final StampaModel? stampa;

  @override
  State<ModificaStampaPop> createState() => _ModificaStampaPopState();
}

class _ModificaStampaPopState extends State<ModificaStampaPop> {
  List<DropdownMenuItem<int>> stampanti_conf = <DropdownMenuItem<int>>[];
  StampaModel? _stampaModel;
  int? stampanteSelezionata;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    Utility.getServerProvider()
        .getListData(ApiConfigurazione.getStampanti, null)
        .then((value) {
      if (value.errore == null) {
        if (value.listData != null) {
          stampanti_conf.addAll(value.listData!.map((e) {
            StampanteModel stampante = StampanteModel.fromJson(e);

            return DropdownMenuItem(
              value: stampante.id_stampante,
              child: Text(stampante.nome_stampante!),
            );
          }).toList());
        } else {
          Utility.mostraErrorDialog(
                  context, '', S.current.msg_elemento_non_trovato.capitalize())
              .then((value) => Navigator.of(context).pop());
        }
      } else {
        Utility.mostraErrorDialog(
            context, S.current.attenzione.capitalize(), value.errore!);
      }
      setState(() {});
    });

    if (widget.stampa != null) {
      //carico dal server i valori
      Utility.getServerProvider()
          .getData(ApiConfigurazione.getStampa, widget.stampa!.toJson(),
              isPopup: true)
          .then((value) {
        if (value.errore == null) {
          if (value.data != null) {
            _stampaModel = StampaModel.fromJson(value.data!);
            stampanteSelezionata = _stampaModel!.id_stampante_def;
          } else {
            Utility.mostraErrorDialog(context, '',
                    S.current.msg_elemento_non_trovato.capitalize())
                .then((value) => Navigator.of(context).pop());
          }
        } else {
          Utility.mostraErrorDialog(context, '', value.errore!)
              .then((value) => Navigator.of(context).pop());
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GenericPagePopup(
      titolo:
          '${S.current.modifica.capitalize()} ${S.current.stampa.capitalize()}',
      azioni: [
        IconButton(
          onPressed: () {
            salva();
          },
          icon: const Icon(Icons.save_outlined),
          tooltip: S.current.salva,
        )
      ],
      pageBody: Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.only(top: ValoriDefault.defaultPadding),
            child: Column(
              children: [
                DropdownButtonFormField(
                  items: stampanti_conf,
                  isDense: true,
                  value: stampanteSelezionata,
                  disabledHint: Text(S.current.caricamento),
                  decoration: InputDecoration(
                    labelText: '${S.current.stampanti} ${S.current.defaul}'
                        .capitalize(), //stampanti_disponibili
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      stampanteSelezionata = value;
                    });
                  },
                ),
                const SizedBox(
                  height: ValoriDefault.defaultPadding,
                ),
              ],
            )),
      ),
    );
  }

  void salva() {
    if (_formKey.currentState!.validate()) {
      Utility.mostraConfermaDialog(
              context, '', S.current.msg_conferma_salvataggio)
          .then((value) {
        if (value != null && value) {
          StampaModel stamp = StampaModel(
              id_stampa: _stampaModel!.id_stampa,
              id_stampante_def: stampanteSelezionata);
          Utility.getServerProvider()
              .postData(ApiConfigurazione.salvaStampa, stamp.toJson(),
                  isPopup: true)
              .then((value) {
            if (value.errore != null) {
              Utility.mostraErrorDialog(context, '', value.errore!);
            } else {
              Navigator.of(context).pop(true);
            }
          });
        }
      });
    }
  }
}
