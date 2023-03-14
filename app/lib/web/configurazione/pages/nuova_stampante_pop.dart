// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/configurazione/models/stampante_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';
import 'package:ows_test_v2/generale/pages/generic_page_popup.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';

class NuovaStampantePop extends StatefulWidget {
  static double larghezza = 550;
  static double altezza = 300;

  final StampanteModel? stampante;

  const NuovaStampantePop({super.key, this.stampante});

  @override
  State<NuovaStampantePop> createState() => _NuovaStampantePopState();
}

class _NuovaStampantePopState extends State<NuovaStampantePop> {
  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> stampanti_installate =
      <DropdownMenuItem<String>>[];
  StampanteModel? _stampanteServer;
  String? stampante_selezionata;
  TextEditingController controllerDesc = TextEditingController();

  @override
  void initState() {
    Utility.getServerProvider()
        .getListData(ApiConfigurazione.getStampantiServer, null)
        .then((value) {
      if (value.errore == null) {
        if (value.listData != null) {
          stampanti_installate.addAll(value.listData!.map(
            (e) => DropdownMenuItem(
              value: e['value'],
              child: Text(e['value']!),
            ),
          ));
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

    if (widget.stampante != null) {
      //carico dal server i valori
      Utility.getServerProvider()
          .getData(ApiConfigurazione.getStampante, widget.stampante!.toJson(),
              isPopup: true)
          .then((value) {
        if (value.errore == null) {
          if (value.data != null) {
            _stampanteServer = StampanteModel.fromJson(value.data!);
            stampante_selezionata = _stampanteServer!.nome_stampante;
            controllerDesc.text = _stampanteServer!.desc_stampante ?? '';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericPagePopup(
      titolo: widget.stampante == null
          ? S.current.nuova_stampante.capitalize()
          : S.current.modifica_stampante.capitalize(),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return S.current.msg_campo_vuoto;
                    }
                    return null;
                  },
                  items: stampanti_installate,
                  isDense: true,
                  value: stampante_selezionata,
                  disabledHint: Text(S.current.caricamento),
                  decoration: InputDecoration(
                    labelText: S.current.stampanti
                        .capitalize(), //stampanti_disponibili
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      stampante_selezionata = value;
                    });
                  },
                ),
                const SizedBox(
                  height: ValoriDefault.defaultPadding,
                ),
                TextFormField(
                  maxLength: 100,
                  controller: controllerDesc,
                  decoration: InputDecoration(
                      labelText: S.current.descrizione.capitalize()),
                ),
              ],
            )),
      ),
    );
  }

  void salva() {
    if (_formKey.currentState!.validate()) {
      Future<bool?> ok = Utility.mostraConfermaDialog(
          context, '', S.current.msg_conferma_salvataggio);
      ok.then((value) {
        if (value != null && value) {
          StampanteModel stamp = StampanteModel(
              id_stampante:
                  _stampanteServer == null ? 0 : _stampanteServer!.id_stampante,
              nome_stampante: stampante_selezionata,
              desc_stampante: controllerDesc.text);
          Future<ResponseModel> res = Utility.getServerProvider().postData(
              ApiConfigurazione.salvaStampante, stamp.toJson(),
              isPopup: true);
          res.then((newvalue) {
            if (newvalue.errore != null) {
              Utility.mostraErrorDialog(context, '', newvalue.errore!);
            } else {
              Navigator.of(context).pop(true);
            }
          });
        }
      });
    }
  }
}
