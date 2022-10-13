import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import 'src/data.dart';

class GeneralScrollViewWidget extends StatefulWidget {
  const GeneralScrollViewWidget();
  @override
  State<StatefulWidget> createState() {
    return _GeneralScrollViewWidgetState();
  }
}

class _GeneralScrollViewWidgetState extends State<GeneralScrollViewWidget> {
  late final AnchorScrollController _scrollController;

  TabController? _tabController;
  int length = 1;

  @override
  void initState() {
    super.initState();

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
          title: Text("CodBar - Produtos"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: movies3.length,
                    itemBuilder: (context, index) => AnchorItemWrapper(
                        index: index,
                        controller: _scrollController,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Center(
                                child: Container(
                              height: 160,
                              width: 270,
                              margin: EdgeInsets.fromLTRB(05, 60, 0, 60),
                              child: SfBarcodeGenerator(
                                value: movies3[index],
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
                  animationDuration: Duration(seconds: length * 6),
                  length: movies3.length,
                  child: Builder(builder: (context) {
                    _tabController = DefaultTabController.of(context);
                    return TabBar(
                        isScrollable: true,
                        tabs: List.generate(
                            movies3.length,
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
                          length = index;
                          _scrollController.scrollToIndex(
                              index: index, scrollSpeed: 0.1);
                        });
                  }),
                ),
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
