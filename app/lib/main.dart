import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:ows_test_v2/autenticazione/pages/login_page.dart';
import 'package:ows_test_v2/generale/pages/main_page.dart';
import 'package:ows_test_v2/autenticazione/providers/utente_provider.dart';
import 'package:ows_test_v2/generale/providers/error_provider.dart';
import 'package:ows_test_v2/generale/providers/server_provider.dart';
import 'package:ows_test_v2/generale/widgets/configurazione_server_dialog.dart';
import 'package:ows_test_v2/generale/widgets/menu_laterale.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:ows_test_v2/web/generale/pages/gestione_utenti_page.dart';
import 'package:ows_test_v2/web/configurazione/pages/parametri_generali_page.dart';
import 'package:ows_test_v2/web/configurazione/pages/gestione_stampe_page.dart';
import 'package:ows_test_v2/web/generale/pages/test_bluetooth.dart';
import 'package:ows_test_v2/web/generale/pages/test_speech_to_text.dart';
import 'package:ows_test_v2/web/generale/pages/web_default_page.dart';
import 'package:ows_test_v2/web/magazzino/pages/gestione_udc_page.dart';
import 'package:ows_test_v2/web/magazzino/pages/mappatura_magazzino_page.dart';
import 'package:ows_test_v2/web/generale/pages/gestione_text_to_speech.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton<ServerProvider>(ServerProvider());
  GetIt.I.registerSingleton<MenuLateraleStato>(MenuLateraleStato());

  FlutterError.onError = (details) {
    //FlutterError.presentError(details);
    if (kDebugMode) {
      print(details.exception);
      print(details.stack);
    }

    if (details.exception is Exception) {
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: Text("${details.exception} ${details.stack}")),
        ),
      ));
    }
  };
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UtenteProvider>(create: (context) {
        UtenteProvider ut = UtenteProvider();
        GetIt.I.registerSingleton<UtenteProvider>(ut);
        ut.fromSharedPreferences();

        return ut;
      }),
      ChangeNotifierProvider<ErrorProvider>(create: (context) {
        return ErrorProvider();
      }),
      ChangeNotifierProvider<ServerProvider>(create: (context) {
        return GetIt.I<ServerProvider>();
      }),
    ],
    //Utilizzo un futureBuilder per essere sicuro di aver inizializzato il baseUrl di dio , prima della prima chiamata api
    child: FutureBuilder<String>(
      future: Utility.getServerProvider().getUrl(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const OwsApp();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  ));
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class OwsApp extends StatelessWidget {
  const OwsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    S.load(const Locale('it'));
    /* return FutureProvider(
      create: (context) => ServerProvider().getData("192.168.0.168:150"),
      initialData: "loading...",
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: const MainPage(title: 'OWS')),
    );*/
    Map<String, Widget Function(BuildContext)> pagine =
        <String, Widget Function(BuildContext)>{
      '/web/mappatura_magazzino': (context) => const MappaturaMagazzinoPage(),
      '/web/gestione_utenti': (context) => const GestioneUtentiPage(),
      '/web/parametri_generali': (context) => const ParametriGeneraliPage(),
      '/web/gestione_stampe': (context) => const GestioneStampePage(),
      '/web/gestione_udc': (context) => const GestioneUdcPage(),
      // '/web/gestione_TTS': (context) => const GestioneTextToSpeech(),
      // '/web/gestione_STT': (context) => const SpeechSampleApp(),
      // '/web/test_bluetooth': (context) => const BluetoothConnection(),
    };

    return MaterialApp(
      //scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      //routes: pagine,
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          settings:
              settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works

          pageBuilder: (context, animation, secondaryAnimation) {
            return pagine[settings.name]!(context);
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },

      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'OWS',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          appBarTheme: AppBarTheme(
            color: Colors.blueGrey[100],
            actionsIconTheme: IconThemeData(color: Colors.grey[700]),
            iconTheme: IconThemeData(color: Colors.grey[700]),
          ),
          inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.blueGrey.shade300,
                width: 2,
              ))),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize:
                  const Size.fromHeight(ValoriDefault.defaultAltezzaPulsante),
              backgroundColor: Colors.blueGrey[100],
              foregroundColor: Colors.grey[700],
            ),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black))),
      home: Consumer<UtenteProvider>(
        builder: (context, value, child) {
          if (value.isLoggato) {
            if (kIsWeb) {
              return const WebDefaultPage();
            } else {
              return const MainPage();
            }
          } else {
            //chiudo tutte le eventuali finestre aperte sopra la main
            Future.delayed(
              Duration.zero,
              () {
                Navigator.of(context).popUntil(
                  (route) {
                    return route.isFirst;
                  },
                );

                Utility.getServerProvider().getUrl().then(
                  (value) {
                    if (value == "") {
                      Future<String> url =
                          ConfigurazioneServerDialog.mostraDialog(context);
                      url.then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return const OwsApp();
                          },
                        ));
                      });
                    }
                  },
                );
              },
            );

            return const LoginPage();
          }
        },
      ),
      //home: kIsWeb ? const WebDefaultPage() : const MainPage(),
    );
  }
}
