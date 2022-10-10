import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

void main() {
  return runApp(MyApp());
}

/// Creates the barcode generator
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Barcode Generator Demo'),
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Container(
                    height: 150,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: SfBarcodeGenerator(
                      value: '123456789',
                      symbology: Codabar(),
                      showValue: true,
                    ),
                  )),
                )
              ],
            )));
  }
}

// import 'package:automatic_animated_list/automatic_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_barcodes/barcodes.dart';

// void main() {
//   return runApp(MyApp());
// }

// /// Creates the barcode generator
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Barcode Generator Demo'),
//           ),
//           body: ListView(children: <Widget>[
//             Container(
//               height: 150,
//               margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//               child: SfBarcodeGenerator(
//                 value: '123456',
//                 symbology: Codabar(module: 4),
//                 showValue: true,
//               ),
//             ),
//           ])),
//     );
//   }
// }
