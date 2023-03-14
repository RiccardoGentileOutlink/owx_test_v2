import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ows_test_v2/generated/l10n.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'alert_dialog_modale.dart';

class ConfigurazioneServerDialog {
  static Future<String> mostraDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) {
        String messaggio = "";
        bool testOk = false;
        bool isLoading = false;
        TextEditingController controllerUrl = TextEditingController();
        Future<String> defaultUrl = Utility.getParametroConfigurazione('base_url');
        defaultUrl.then((defaultUrlValue) => Utility.getUrl().then((value) => value != '' ? controllerUrl.text = value : controllerUrl.text = defaultUrlValue));

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialogModale(
              AlertDialog(
                title: Text(S.of(context).msg_url_server),
                content: SizedBox(
                  width: ValoriDefault.defaultLarghezza,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: ValoriDefault.defaultPadding),
                        child: TextFormField(
                          autofocus: true,
                          controller: controllerUrl,
                        ),
                      ),
                      Text(
                        messaggio,
                        style: TextStyle(color: testOk ? Colors.green : Colors.red),
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
                        String urlResult = controllerUrl.text;
                        setState(
                          () => isLoading = true,
                        );
                        Future<bool> okResult = _testaConnessione(urlResult);
                        okResult.then(
                          (value) {
                            if (value) {
                              setState(
                                () {
                                  isLoading = false;
                                  messaggio = S.of(context).test_superato;
                                  testOk = true;
                                },
                              );
                            } else {
                              setState(
                                () {
                                  isLoading = false;
                                  messaggio = S.of(context).test_non_superato;
                                  testOk = false;
                                },
                              );
                            }
                          },
                        );
                      },
                      child: Text(S.of(context).test_connessione)),
                  TextButton(
                      onPressed: () {
                        String urlResult = controllerUrl.text;
                        setState(
                          () => isLoading = true,
                        );
                        Future<bool> okResult = _testaConnessione(urlResult);
                        okResult.then((value) {
                          if (value) {
                            Navigator.pop(context, urlResult);
                          } else {
                            setState(
                              () {
                                isLoading = false;
                                messaggio = S.of(context).test_non_superato;
                                testOk = false;
                              },
                            );
                          }
                        });
                      },
                      child: Text(S.of(context).salva_ed_esci))
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((prefInstance) {
        prefInstance.setString(DatiMemoria.url, value!);
        Utility.getServerProvider().setUrl(value);
      });
      return value!;
    });
  }

  static Future<bool> _testaConnessione(String urlResult) async {
    //return Future.delayed(Duration(seconds: 5)).then((value) => true);
    bool isOnline = await Utility.isOnline();
    if (isOnline) {
      try {
        //Uri url = Uri.parse(urlResult);
        // http.Response response = await http.get(url, headers: <String, String>{"Access-Control-Allow-Origin": "*", "Accept": "*/*"});
        // http.Response response = await http.get(url, headers: <String, String>{"Access-Control-Allow-Origin": "*", "Accept": "*/*"});
        Dio dio = Dio();
        Response response = await dio.get(urlResult, queryParameters: null);

        if (response.statusCode == 200) {
          return true;
        }
      } on Error catch (_) {
        return false;
      } on Exception catch (_) {
        return false;
      }
      return false;
    } else {
      return false;
    }
  }
}
