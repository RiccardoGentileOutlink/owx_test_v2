import 'package:flutter/material.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/providers/error_provider.dart';
import 'package:ows_test_v2/generale/providers/server_provider.dart';
import 'package:ows_test_v2/generale/widgets/contenitore_messaggio.dart';
import 'package:ows_test_v2/generale/widgets/menu_laterale.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class GenericScaffold extends StatefulWidget {
  final String appBarTitle;
  final Widget body;
  final Widget? footer;
  final bool mostraDrawer;
  final List<Widget> elementiAppBar;

  const GenericScaffold({this.appBarTitle = '', required this.body, this.footer, this.mostraDrawer = true, required this.elementiAppBar, super.key});

  @override
  State<GenericScaffold> createState() => _GenericScaffoldState();
}

class _GenericScaffoldState extends State<GenericScaffold> {
  final List<Widget> _elementiAppBarState = <Widget>[];

  @override
  Widget build(BuildContext context) {
    _elementiAppBarState.clear();
    _elementiAppBarState.addAll(widget.elementiAppBar);
    _elementiAppBarState.add(Container(
      width: 25,
    ));
    _elementiAppBarState.add(Builder(builder: (context) {
      if (Utility.getUtenteProvider().isLoggato) {
        return IconButton(tooltip: S.current.logout, onPressed: () => _logout(context), icon: const Icon(Icons.logout));
      } else {
        return Container();
      }
    }));
    return Stack(children: [
      Scaffold(
        drawer: widget.mostraDrawer ? const Drawer(child: MenuLaterale()) : null,
        appBar: AppBar(
          title: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (widget.appBarTitle != "") {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    snapshot.data != null ? snapshot.data!.appName : '',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    widget.appBarTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ]);
              } else {
                return Text(
                  snapshot.data != null ? snapshot.data!.appName : '',
                  style: TextStyle(color: Colors.grey[700]),
                );
              }
            },
          ),
          actions: _elementiAppBarState,
        ),
        body: Builder(builder: (context) {
          return Consumer<ErrorProvider>(
            builder: (context, value, child) {
              if (value.errore != null) {
                return AlertDialog(
                  content: SizedBox(
                    height: ValoriDefault.defaultAltezzaPulsante * 3,
                    child: ContenitoreMessaggio(
                      testo: value.errore!,
                      tipo: ContenitoreMessaggio.tipoErrore,
                    ),
                  ),
                  actions: [
                    Visibility(
                      visible: value.stackTrace != null,
                      child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(content: Text(value.stackTrace!), actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(S.current.ok.toUpperCase()))
                                ]);
                              },
                            );
                          },
                          child: Text(S.current.dettaglio.capitalize())),
                    ),
                    TextButton(
                        onPressed: () {
                          Provider.of<ErrorProvider>(context, listen: false).setErrore(null);
                        },
                        child: Text(S.current.ok.toUpperCase()))
                  ],
                );
              } else {
                return widget.body;
              }
            },
          );
          //return widget.body;
        }),
        bottomNavigationBar: widget.footer,
      ),
      Consumer<ServerProvider>(
        builder: (context, value, child) {
          child ??= Container(
            color: Colors.white.withOpacity(0.5),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
          return Visibility(
            visible: value.mostraProgress,
            child: child,
          );
        },
      )
    ]);
  }

  _logout(BuildContext context) {
    /*setState(() {
      isLoading = true;
    });*/

    //UtenteProvider provider = Provider.of<UtenteProvider>(context, listen: false);

    Utility.getUtenteProvider().disconnetti();
  }
}
