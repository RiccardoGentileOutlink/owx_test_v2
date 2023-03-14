import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/autenticazione/models/azienda_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';
import 'package:ows_test_v2/generale/widgets/contenitore_messaggio.dart';
import 'package:ows_test_v2/generale/widgets/password_input_text.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generale/pages/generic_page.dart';
import '../models/utente_model.dart';
import '../providers/utente_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _mostraErroreLogin = false;
  bool _mostraMessaggioDisconnesso =
      Utility.getUtenteProvider().mostraMessaggioDisconnesso;
  String _erroreLogin = "";
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  List<DropdownMenuItem<int>> aziende = <DropdownMenuItem<int>>[];
  List<AziendaModel> listaAziende = <AziendaModel>[];
  int? aziendaSelezionata = 0;

  @override
  void initState() {
    Future<ResponseModel> response = Utility.getServerProvider()
        .getListData(ApiAutenticazione.getAziende, null, mostraProgress: false);
    response.then((value) {
      if (value.errore == null) {
        try {
          aziende.clear();
          listaAziende.clear();
          for (var element in value.listData!) {
            AziendaModel az = AziendaModel.fromJson(element);
            listaAziende.add(az);
            aziende.add(DropdownMenuItem<int>(
              value: az.id_azienda,
              child: Text(az.ragione_sociale!),
            ));
          }

          if (aziende.length == 1) {
            Utility.getUtenteProvider().azienda = listaAziende[0];
            setState(() {
              aziendaSelezionata = aziende[0].value!;
            });
          }
        } on Error catch (err) {
          Utility.setErrore(context, err.toString(),
              stack: err.stackTrace.toString());
        }
      } else {
        Utility.setErrore(context, value.errore!);
      }
      setState(() {});
    });

    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      isChecked = value.getBool(DatiMemoria.ricordaLogin)!;
      if (isChecked) {
        controllerUsername.text = value.getString(DatiMemoria.username)!;
        controllerPassword.text = value.getString(DatiMemoria.password)!;
      }
      setState(() {
        aziendaSelezionata = value.getInt(DatiMemoria.id_azienda);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericPage(
      isLogin: true,
      mostraMenuWeb: false,
      appBarTitle: S.of(context).titolo_login.capitalize(),
      pageBody: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
            child: SizedBox(
              width: ValoriDefault.defaultLarghezza,
              child: Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: ValoriDefault.defaultPadding,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.msg_campo_vuoto;
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          _accedi(context);
                        } else {}
                      },
                      controller: controllerUsername,
                      decoration: InputDecoration(
                          isDense: false,
                          labelText: S.of(context).username.capitalize(),
                          prefixIcon: const Icon(Icons.account_circle)),
                    ),
                    PasswordInputText(
                      isDense: false,
                      label: S.current.password,
                      controller: controllerPassword,
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          _accedi(context);
                        } else {}
                      },
                    ),
                    const SizedBox(
                      height: ValoriDefault.defaultPadding,
                      width: 1,
                    ),
                    DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null) {
                          return S.current.msg_campo_vuoto;
                        }
                        return null;
                      },
                      items: aziende,
                      isDense: true,
                      value: aziendaSelezionata,
                      disabledHint: Text(S.current.caricamento),
                      decoration: InputDecoration(
                        labelText: S.of(context).azienda.capitalize(),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        Utility.getUtenteProvider().azienda =
                            listaAziende.firstWhere(
                                (element) => element.id_azienda == value);
                        setState(() {
                          aziendaSelezionata = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: ValoriDefault.defaultPadding,
                      width: 1,
                    ),
                    CheckboxListTile(
                      value: isChecked,
                      contentPadding: const EdgeInsets.only(right: 283),
                      title: Text('Remember Me'),
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Builder(builder: (context) {
                      if (_isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _accedi(context);
                                } else {}
                              },
                              child: Text(S.of(context).accedi.capitalize()),
                            ),
                            Visibility(
                              visible: _mostraErroreLogin,
                              child: ContenitoreMessaggio(
                                  testo: _erroreLogin,
                                  tipo: ContenitoreMessaggio.tipoErrore),
                            ),
                            Visibility(
                              visible: _mostraMessaggioDisconnesso,
                              child: ContenitoreMessaggio(
                                  testo: S.current.msg_utente_disconnesso
                                      .capitalize(),
                                  tipo: ContenitoreMessaggio.tipoAlert),
                            ),
                          ],
                        );
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _accedi(BuildContext context) async {
    Utility.getUtenteProvider().azienda = listaAziende
        .firstWhere((element) => element.id_azienda == aziendaSelezionata);
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      value.setInt(DatiMemoria.id_azienda,
          Utility.getUtenteProvider().azienda!.id_azienda!);
      value.setString(DatiMemoria.ragSocAzienda,
          Utility.getUtenteProvider().azienda!.ragione_sociale!);
      if (isChecked) {
        value.setString(DatiMemoria.username, controllerUsername.text);
        value.setString(DatiMemoria.password, controllerPassword.text);
        value.setBool(DatiMemoria.ricordaLogin, true);
      } else {
        value.setString(DatiMemoria.username, '');
        value.setString(DatiMemoria.password, '');
        value.setBool(DatiMemoria.ricordaLogin, false);
      }
    });
    setState(() {
      _isLoading = true;
      _mostraErroreLogin = false;
    });

    // UtenteProvider provider = Provider.of<UtenteProvider>(context, listen: false);
    UtenteProvider provider = Utility.getUtenteProvider();

    Future<ResponseModel> loggato = provider.accedi(
      UtenteModel(
        username: controllerUsername.text,
        password: controllerPassword.text,
        id_azienda_sel: aziendaSelezionata,
      ),
    );

    loggato.then((value) {
      if (value.errore != null) {
        setState(() {
          _isLoading = false;
          _mostraErroreLogin = true;
          _mostraMessaggioDisconnesso =
              false; //imposto a false, lo mostro solo la prima volta se arrivo da disconessione server
          _erroreLogin = value.errore.toString();
        });
      } else {
        provider.setLoggato();
      }
    });
  }
}
