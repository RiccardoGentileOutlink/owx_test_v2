import 'package:flutter/material.dart';
import 'package:ows_test_v2/autenticazione/providers/utente_provider.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/widgets/configurazione_server_dialog.dart';
import 'package:ows_test_v2/generale/widgets/generic_scaffold.dart';
import 'package:ows_test_v2/generale/widgets/menu_laterale.dart';
import 'package:ows_test_v2/main.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:provider/provider.dart';

class GenericPage extends StatelessWidget {
  static const double breakPoint = 1100;
  final Widget pageBody;
  final String appBarTitle;
  final Widget? footer;
  final bool mostraMenuWeb;
  final bool isLogin;
  final List<Widget>? elementiAppBar;

  ///true se si vuole che il widget occupi tutto lo spazio a dispozione, false se si vuole dare una dimensione fissa al widget
  ///default su true
  final bool expand;

  const GenericPage(
      {required this.pageBody,
      this.appBarTitle = '',
      this.footer,
      this.mostraMenuWeb = true,
      this.isLogin = false,
      this.elementiAppBar,
      this.expand = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    double larghezza = MediaQuery.of(context).size.width;

    Widget pageBodyConMenu =
        _getMenuWeb(pageBody, larghezza >= breakPoint && mostraMenuWeb);
    return Consumer<UtenteProvider>(
      builder: (context, value, child) {
        child ??= GenericScaffold(
          body: pageBodyConMenu,
          appBarTitle: appBarTitle.capitalize(),
          footer: footer,
          mostraDrawer: larghezza < breakPoint || !mostraMenuWeb,
          elementiAppBar: elementiAppBar ?? <Widget>[],
        );
        if (!value.isLoggato && !isLogin) {
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

  Widget _getMenuWeb(Widget pageBody, bool mostraMenu) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: mostraMenu,
          child: const SizedBox(
            width: 300,
            child: MenuLaterale(mostraHeader: false),
          ),
        ),
        Visibility(
          visible: mostraMenu,
          child: Container(width: 0.5, color: Colors.black),
        ),
        Builder(
          builder: (context) {
            if (expand) {
              return Expanded(
                child: pageBody,
              );
            } else {
              return Align(
                alignment: Alignment.topLeft,
                child: pageBody,
              );
            }
          },
        )
      ],
    );
  }
}
