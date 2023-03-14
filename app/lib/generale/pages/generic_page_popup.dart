import 'package:flutter/material.dart';

import 'package:ows_test_v2/autenticazione/providers/utente_provider.dart';
import 'package:ows_test_v2/generale/providers/server_provider.dart';
import 'package:ows_test_v2/generale/widgets/configurazione_server_dialog.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/main.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:provider/provider.dart';

class GenericPagePopup extends StatelessWidget {
  final Widget pageBody;
  final String titolo;
  final bool isLoading;
  final List<Widget> azioni;
  final double? larghezza;
  final double? altezza;
  const GenericPagePopup({super.key, this.titolo = '', this.azioni = const [], required this.pageBody, this.isLoading = false, this.larghezza, this.altezza});

  @override
  Widget build(BuildContext context) {
    azioni.add(IconButton(
        tooltip: S.current.chiudi,
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        icon: const Icon(Icons.close)));
    return Consumer<UtenteProvider>(
      builder: (context, value, child) {
        child ??= Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      color: Theme.of(context).secondaryHeaderColor),
                  child: Padding(
                    padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Text(
                          titolo,
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                        ...azioni,
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
                    child: SingleChildScrollView(
                      child: pageBody,
                    ),
                  ),
                ),
              ],
            ),
            Consumer<ServerProvider>(
              builder: (context, value, child) {
                child ??= Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                return Visibility(
                  visible: value.mostraProgressPopup,
                  child: child,
                );
              },
            )
          ],
        );

        if (!value.isLoggato) {
          Future.delayed(
            Duration.zero,
            () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return const OwsApp();
                },
              ));

              Utility.getServerProvider().getUrl().then(
                (value) {
                  if (value == "") {
                    ConfigurazioneServerDialog.mostraDialog(context);
                  }
                },
              );
            },
          );
        }
        return child;
      },
    );
  }
}
