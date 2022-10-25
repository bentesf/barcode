import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class GeneralScrollViewWidget extends StatefulWidget {
  const GeneralScrollViewWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _GeneralScrollViewWidgetState();
  }
}

class _GeneralScrollViewWidgetState extends State<GeneralScrollViewWidget> {
  late List<List<dynamic>> listaCodigos;
  late List<List<dynamic>> blocoCodigo;
  late int contPage;
  late int tanAnt;
  bool isLoading = false;
  late final AnchorScrollController _scrollController;
  final key = new GlobalKey<ScaffoldState>();
  TabController? _tabController;

  List<PlatformFile>? _paths;
  String? _extension = "csv";
  FileType _pickingType = FileType.custom;

  @override
  void initState() {
    super.initState();
    listaCodigos = List<List<dynamic>>.empty(growable: true);
    blocoCodigo = List<List<dynamic>>.empty(growable: true);
    contPage = 0;
    _scrollController = AnchorScrollController(
      onIndexChanged: (index, userScroll) {
        if (userScroll) {
          _tabController?.animateTo(index);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.format_list_bulleted_sharp),
          title: Text("Codigos - Produtos"),
          actions: <Widget>[
            IconButton(
                onPressed: _openFileExplorer, icon: Icon(Icons.download)),
            IconButton(
                onPressed: () {
                  setState(() {
                    blocoCodigo = [];
                    listaCodigos = [];
                    _paths = [];
                    contPage = 0;
                  });
                },
                icon: Icon(Icons.restore_from_trash)),
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Container(
            child: Text("Pagina: " + contPage.toString()),
          )),
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: blocoCodigo.length,
                  itemBuilder: (context, index) => AnchorItemWrapper(
                      index: index,
                      controller: _scrollController,
                      child: Container(
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Center(
                              child: Container(
                            // color: Colors.blue,
                            height: 160,
                            width: 300,
                            margin: EdgeInsets.fromLTRB(40, 60, 20, 60),
                            child: SfBarcodeGenerator(
                              value: blocoCodigo[index][0],
                              symbology: Codabar(module: 6),
                              showValue: true,
                            ),
                          )),
                        ),
                      )))),
          Container(
            color: Colors.white,
            height: 40,
            alignment: Alignment.centerLeft,
            child: Container(
              height: 30,
              child: DefaultTabController(
                animationDuration: Duration(seconds: 1),
                length: blocoCodigo.length,
                child: Builder(builder: (context) {
                  _tabController = DefaultTabController.of(context);
                  return TabBar(
                      isScrollable: true,
                      tabs: List.generate(
                          blocoCodigo.length,
                          (index) => Container(
                                width: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              )),
                      labelPadding: EdgeInsets.symmetric(horizontal: 5),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        color: Color.fromARGB(255, 21, 116, 180),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      onTap: (index) {
                        _scrollController.scrollToIndex(
                            index: index + 1, scrollSpeed: 0.1);
                      });
                }),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        backgroundColor: Color.fromARGB(255, 43, 118, 231),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          // FAB 1
          SpeedDialChild(
            child: isLoading
                ? CircularProgressIndicator(
                    color: Colors.black,
                  )
                : const Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 43, 118, 231),
            onTap: () {
              setState(() {
                isLoading = true;
              });
              Future.delayed(const Duration(seconds: 3), () {
                remlist(blocoCodigo.length);

                setState(() {
                  isLoading = false;
                });
              });
            },
            label: 'Lista Anterior',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color.fromARGB(255, 43, 118, 231),
          ),
          // FAB 2
          SpeedDialChild(
            child: isLoading
                ? CircularProgressIndicator(
                    color: Colors.black,
                  )
                : const Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 43, 118, 231),
            onTap: () {
              setState(() {
                isLoading = true;
              });
              Future.delayed(const Duration(seconds: 3), () {
                addlist(blocoCodigo.length);

                setState(() {
                  isLoading = false;
                });
              });
            },
            label: 'Nova Lista',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color.fromARGB(255, 43, 118, 231),
          )
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: this._buildBottomAppBar(context),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      // shape: this._isBottomBarNotched ? const CircularNotchedRectangle() : null,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          // Bottom that pops up from the bottom of the screen.
          // IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: () => showModalBottomSheet(
          //     context: context,
          //     builder: (BuildContext context) => Container(
          //       alignment: Alignment.center,
          //       height: 200,
          //       child: const Text('Dummy bottom sheet'),
          //     ),
          //   ),
          // ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}
              // Fluttertoast.showToast(msg: 'Dummy search action.'),
              ),
          IconButton(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(300, 0, 0, 0),
              icon: const Icon(Icons.more_vert),
              onPressed:
                  () {} //=> Fluttertoast.showToast(msg: 'Dummy menu action.'),
              ),
        ],
      ),
    );
  }

  openFile(filepath) async {
    File f = new File(filepath);
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    setState(() {
      listaCodigos = fields;
      // fields = [];
    });
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
    } catch (ex) {}
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      _showSnack();
    });
  }

  addlist(int tan) {
    late List<List<dynamic>> codebar2;
    codebar2 = List<List<dynamic>>.empty(growable: true);
    contPage = contPage + 1;
    blocoCodigo = [];
    tan = contPage * tan;
    if (listaCodigos.isNotEmpty) {
      for (int i = tan; i < tan + 10; i++) {
        listaCodigos[i][0] = listaCodigos[i][0].toString();
        codebar2.add(listaCodigos[i]);
      }

      setState(() {
        for (int i = 0; i < 10; i++) {
          blocoCodigo.add(codebar2[i]);
        }
        // if (tan > tanAnt) {
        contPage++;
        // } else {
        //   contPage--;
        // }
      });
    }
  }

  remlist(int tan) {
    late List<List<dynamic>> codebar2;
    codebar2 = List<List<dynamic>>.empty(growable: true);
    contPage = contPage - 1;
    blocoCodigo = [];
    tan = contPage * tan;
    if (listaCodigos.isNotEmpty) {
      for (int i = tan; i < tan + 10; i++) {
        listaCodigos[i][0] = listaCodigos[i][0].toString();
        codebar2.add(listaCodigos[i]);
      }

      setState(() {
        for (int i = 0; i < 10; i++) {
          blocoCodigo.add(codebar2[i]);
        }
        // if (tan > tanAnt) {
        //   contPage++;
        // } else {
        contPage = contPage - 1;
        // }
      });
    }
  }

  void _showSnack() =>
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Concluido!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        dismissDirection: DismissDirection.up,
      ));

  @override
  void dispose() {
    super.dispose();
  }
}
