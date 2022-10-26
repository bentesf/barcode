import 'package:barcode_generator/image.dart';
import 'package:flutter/material.dart';
import 'general_scroll_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                AppImages.teste2,
                // width: 200,
                height: 120,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Material(
                elevation: 20,
                color: Color.fromARGB(255, 43, 118, 231),
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  animationDuration: Duration(seconds: 0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GeneralScrollViewWidget();
                    }));
                  },
                  minWidth: 190,
                  height: 50,
                  child: Text(
                    'Iniciar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: GeneralScrollViewWidget(),
//     );
//   }
// }