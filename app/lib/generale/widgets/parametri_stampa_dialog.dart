import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/configurazione/models/stampante_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:ows_test_v2/web/magazzino/models/params/stampa_etichette_model.dart';

class ParametriStampaDialog {
  static Future<ParametriGeneraliStampaModel?> mostraDialog(
      BuildContext context, ParametriGeneraliStampaModel model) {
    return showDialog<ParametriGeneraliStampaModel>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) {
        bool isLoading = false;
        List<DropdownMenuItem<int>>? listaStampanti;
        int? stampanteSelezionata;
        TextEditingController controllerQuantita =
            TextEditingController(text: "1");
        return StatefulBuilder(builder: (context, setState) {
          if (model.id_stampante != null) {
            Utility.getServerProvider()
                .getData(ApiConfigurazione.getStampante,
                    StampanteModel(id_stampante: model.id_stampante!).toJson(),
                    mostraProgress: false, isPopup: true)
                .then(
              (value) {
                if (value.errore == null) {
                  setState(
                    () {
                      stampanteSelezionata =
                          StampanteModel.fromJson(value.data!).id_stampante;
                    },
                  );
                }
              },
            );
          }

          Utility.getServerProvider()
              .getListData(ApiConfigurazione.getStampanti, null,
                  mostraProgress: false, isPopup: true)
              .then(
            (value) {
              if (value.errore == null) {
                setState(
                  () {
                    listaStampanti = value.listData!.map(
                      (e) {
                        StampanteModel stampante = StampanteModel.fromJson(e);
                        return DropdownMenuItem(
                          value: stampante.id_stampante,
                          child: Text(stampante.nome_stampante!),
                        );
                      },
                    ).toList();
                  },
                );
              } else {
                Utility.mostraErrorDialog(
                    context, S.current.attenzione.capitalize(), value.errore!);
              }
            },
          );

          return AlertDialog(
            title: Text(S.current.parametri_stampa.capitalize()),
            content: SizedBox(
              width: ValoriDefault.defaultLarghezza,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                    items: listaStampanti,
                    isDense: true,
                    value: stampanteSelezionata,
                    disabledHint: Text(S.current.caricamento),
                    decoration: InputDecoration(
                      labelText: S.current.stampante
                          .capitalize(), //stampanti_disponibili
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        stampanteSelezionata = value;
                      });
                    },
                  ),
                  const Divider(color: Colors.transparent),
                  IntrinsicWidth(
                    stepWidth: 100,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: controllerQuantita,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: S.current.copie.capitalize(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator(),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: Text(S.current.chiudi),
              ),
              TextButton(
                onPressed: () {
                  if (stampanteSelezionata == null) {
                    Utility.mostraAlertDialog(context, S.current.attenzione,
                        S.current.msg_selezionare_stampante.capitalize());
                  } else {
                    Navigator.pop(
                        context,
                        ParametriGeneraliStampaModel(
                            id_stampante: stampanteSelezionata,
                            quantita:
                                int.tryParse(controllerQuantita.text) ?? 1));
                  }
                  //Navigator.pop(context, true);
                },
                child: Text(S.current.stampa),
              )
            ],
          );
        });
      },
    );
  }
}
