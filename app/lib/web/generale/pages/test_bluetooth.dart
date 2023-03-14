// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:ows/estensioni.dart';
// import 'package:ows/generale/models/response_model.dart';
// import 'package:ows/generale/pages/generic_page.dart';
// import 'package:ows/generale/widgets/personal_pluto_grid.dart';
// import 'package:ows/generale/widgets/pulsanti_azioni_tabella.dart';
// import 'package:ows/generated/l10n.dart';
// import 'package:ows/utility.dart';
// import 'package:pluto_grid/pluto_grid.dart';

// class BluetoothConnection extends StatefulWidget {
//   const BluetoothConnection({super.key});

//   @override
//   State<BluetoothConnection> createState() => _BluetoothConnectionState();
// }

// class _BluetoothConnectionState extends State<BluetoothConnection> {
//   Future<ResponseModel>? _futureGetConnesioni;
//   PlutoGridStateManager? _plutoStateManagerConnessione;
//   late List<PlutoColumn> _colonne;
//   late List<PlutoRow> _righe;
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

//   @override
//   void initState() {
//     super.initState();
//     _colonne = [
//       PlutoColumn(
//         hide: true,
//         title: S.current.id.capitalize(),
//         field: 'col1',
//         type: PlutoColumnType.number(),
//       ),
//       PlutoColumn(
//         hide: false,
//         title: S.current.nome.capitalize(),
//         field: 'col2',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         hide: false,
//         title: S.current.descrizione.capitalize(),
//         field: 'col3',
//         type: PlutoColumnType.text(),
//       ),
//       // PlutoColumn(
//       //   title: '',
//       //   field: 'azioni',
//       //   type: PlutoColumnType.text(),
//       //   enableContextMenu: false,
//       //   enableDropToResize: false,
//       //   width: 60,
//       //   minWidth: 100,
//       //   renderer: (rendererContext) {
//       //     return Row(
//       //       children: [
//       //         PulsanteModifica(
//       //           azione: () {},
//       //         ),
//       //         PulsanteElimina(
//       //           azione: () {},
//       //         )
//       //       ],
//       //     );
//       //   },
//       // ),
//     ];

//     _futureGetConnesioni = _getDevice();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GenericPage(
//         appBarTitle: 'test bluetooth',
//         elementiAppBar: [
//           TextButton(
//               onPressed: _getDevice, child: const Text('cerca connessioni'))
//         ],
//         pageBody: Container(
//           child: _getWidgetConnessioni(),
//         ));
//   }

//   Widget _getWidgetConnessioni() {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _futureGetConnesioni,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             double larghezza = 850;
//             double larghezzaSchermo = MediaQuery.of(context).size.width;
//             if (larghezzaSchermo > GenericPage.breakPoint) {
//               larghezza = min(larghezzaSchermo - 400, 850);
//             } else {
//               larghezza = min(larghezzaSchermo, 850);
//             }
//             return Container(
//               constraints: BoxConstraints(maxWidth: larghezza),
//               child: Padding(
//                 padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
//                 child: PersonalPlutoGrid(
//                   colonne: _colonne,
//                   righe: _righe,
//                   mostraFiltri: false,
//                   setPlutoGridStateManager: (p0) {
//                     _plutoStateManagerConnessione = p0;
//                   },
//                   //autoSize: PlutoAutoSizeMode.none,
//                 ),
//               ),
//             );
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }

//   Future<ResponseModel>? _getDevice() {
//     // Start scanning
//     flutterBlue.startScan(timeout: const Duration(seconds: 20));

// // Listen to scan results
//     var subscription = flutterBlue.scanResults.listen((results) {
//       // do something with scan results
//       for (ScanResult r in results) {
//         print('${r.device.name} found! rssi: ${r.rssi}');
//       }
//     });

// // Stop scanning
//     flutterBlue.stopScan();
//     return null;
//   }
// }
