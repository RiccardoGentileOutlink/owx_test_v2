import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ows_test_v2/api.dart';
import 'package:ows_test_v2/autenticazione/models/utente_model.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/models/response_model.dart';
import 'package:ows_test_v2/generale/pages/generic_page_popup.dart';
import 'package:ows_test_v2/generale/widgets/password_input_text.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';

class NuovoUtentePop extends StatefulWidget {
  static double altezza = 680;
  static double larghezza = 500;

  final UtenteModel? utente;

  const NuovoUtentePop({super.key, this.utente});

  @override
  State<NuovoUtentePop> createState() => _NuovoUtentePopState();
}

class _NuovoUtentePopState extends State<NuovoUtentePop> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCognome = TextEditingController();
  TextEditingController controllerMail = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfermaPassword = TextEditingController();
  bool _attivo = true;
  TipoUtente? _tipoUtente;

  final _formKey = GlobalKey<FormState>();

  UtenteModel? _utenteServer;

  bool _modificaPassword = false;

  @override
  void initState() {
    super.initState();

    if (widget.utente != null) {
      Future<ResponseModel> resUtente = Utility.getServerProvider()
          .getData(ApiAutenticazione.getUtente, widget.utente!.toJson());
      resUtente.then(
        (value) {
          if (value.errore == null) {
            if (value.data != null) {
              _utenteServer = UtenteModel.fromJson(value.data!);
              controllerNome.text = _utenteServer!.nome ?? '';
              controllerCognome.text = _utenteServer!.cognome ?? '';
              controllerMail.text = _utenteServer!.mail ?? '';
              controllerUsername.text = _utenteServer!.username ?? '';
              _attivo = _utenteServer!.attivo;
              _tipoUtente = _utenteServer!.tipo_utente;
              setState(() {});
            } else {
              Utility.mostraErrorDialog(context, '',
                      S.current.msg_elemento_non_trovato.capitalize())
                  .then((value) => Navigator.of(context).pop());
            }
          } else {
            Utility.mostraErrorDialog(context, '', value.errore!)
                .then((value) => Navigator.of(context).pop());
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GenericPagePopup(
      titolo: widget.utente == null
          ? S.current.nuovo_utente.capitalize()
          : S.current.modifica_utente.capitalize(),
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
          child: Column(children: [
            TextFormField(
              maxLength: 100,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.msg_campo_vuoto;
                }
                return null;
              },
              controller: controllerNome,
              decoration:
                  InputDecoration(labelText: S.of(context).nome.capitalize()),
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
            TextFormField(
              maxLength: 100,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.msg_campo_vuoto;
                }
                return null;
              },
              controller: controllerCognome,
              decoration: InputDecoration(
                  labelText: S.of(context).cognome.capitalize()),
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.msg_campo_vuoto;
                }
                return EmailValidator.validate(value)
                    ? null
                    : S.current.msg_mail_non_valida;
              },
              controller: controllerMail,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  InputDecoration(labelText: S.of(context).mail.capitalize()),
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
            DropdownButtonFormField(
              items: [
                DropdownMenuItem(
                  value: TipoUtente.operatoreMagazzino,
                  child: Text(S.current.operatore_magazzino.capitalize()),
                ),
                DropdownMenuItem(
                  value: TipoUtente.responabileMagazzino,
                  child: Text(S.current.responsabile_magazzino.capitalize()),
                ),
                DropdownMenuItem(
                  value: TipoUtente.admin,
                  child: Text(S.current.admin.capitalize()),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _tipoUtente = value;
                });
              },
              value: _tipoUtente,
              decoration: InputDecoration(
                labelText: S.of(context).tipo_utente.capitalize(),
                isDense: true,
              ),
              validator: (value) {
                if (value == null) {
                  return S.current.msg_campo_vuoto;
                }
                return null;
              },
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
            Row(
              children: [
                Checkbox(
                  value: _attivo,
                  onChanged: (value) {
                    setState(
                      () => _attivo = value!,
                    );
                  },
                ),
                Text(S.of(context).attivo.capitalize()),
              ],
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding * 3,
            ),
            TextFormField(
              maxLength: 50,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.msg_campo_vuoto;
                }
                return null;
              },
              controller: controllerUsername,
              decoration: InputDecoration(
                  labelText: S.of(context).username.capitalize()),
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Visibility(
                  visible: _utenteServer != null,
                  child: TextButton(
                    child: Text(
                      '${S.current.modifica.capitalize()} ${S.current.password}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      setState(() {
                        _modificaPassword = !_modificaPassword;
                      });
                    },
                  )),
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
            Visibility(
              visible: _utenteServer == null || _modificaPassword,
              child: PasswordInputText(
                mostraCounter: true,
                mostraIcona: false,
                label: S.current.password,
                controller: controllerPassword,
                validator: (value) {
                  //se sono in modifica non controllo la password a meno che non vado a modificarla
                  if (_utenteServer != null && value == '') {
                    return null;
                  }
                  if (value != null && value.length < 5) {
                    return S.current.msg_lunghezza_password_minima(5);
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
            Visibility(
              visible: _utenteServer == null || _modificaPassword,
              child: PasswordInputText(
                mostraCounter: true,
                mostraIcona: false,
                label: S.current.conferma_password,
                controller: controllerConfermaPassword,
                validator: (value) {
                  //se sono in modifica non controllo la password a meno che non vado a modificarla
                  if (_utenteServer != null && value == '') {
                    return null;
                  }
                  if (value != null && value != controllerPassword.text) {
                    return S.current.msg_conferm_mail_non_corrisponde;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: ValoriDefault.defaultPadding,
            ),
          ]),
        ),
      ),
    );
  }

  void salva() {
    if (_formKey.currentState!.validate()) {
      Future<bool?> ok = Utility.mostraConfermaDialog(
          context, '', S.current.msg_conferma_salvataggio);
      ok.then(
        (value) {
          if (value != null && value) {
            UtenteModel ut = UtenteModel(
              id_utente: _utenteServer == null ? 0 : _utenteServer!.id_utente,
              nome: controllerNome.text,
              cognome: controllerCognome.text,
              mail: controllerMail.text,
              attivo: _attivo,
              username: controllerUsername.text,
              password: controllerPassword.text,
              tipo_utente: _tipoUtente ?? TipoUtente.operatoreMagazzino,
            );
            Future<ResponseModel> res = Utility.getServerProvider().postData(
                _utenteServer == null
                    ? ApiAutenticazione.creaUtente
                    : ApiAutenticazione.modificaUtente,
                ut.toJson(),
                isPopup: true);
            res.then(
              (value) {
                if (value.errore != null) {
                  Utility.mostraErrorDialog(context, '', value.errore!);
                } else {
                  Navigator.of(context).pop(true);
                }
              },
            );
          }
        },
      );
    }
  }
}
