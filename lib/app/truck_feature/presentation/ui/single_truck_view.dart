import 'package:app/app/truck_feature/domain/entities/truck/truck_entity.dart';
import 'package:app/app/truck_feature/presentation/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SingleTruckView extends StatelessWidget {
  const SingleTruckView({super.key, required this.data});
  final FoodTruck data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.applicant),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://prestigefoodtrucks.com/wp-content/uploads/2022/01/joana-godinho-Gwv-t9VQiPM-unsplash-twitter.jpg",
                          scale: 1))),
            ),
          ),
          MyDraggableScrollableSheet(
            foodTruck: data,
          )
        ],
      ),

//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             floating: false,
//             pinned: true,
//             automaticallyImplyLeading: false,
//             expandedHeight: MediaQuery.of(context).size.height * .3,
//             collapsedHeight: 150,
//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
// // background: Container(color: Colors.red,),
//               background: Image.network(
//                 "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Icon(Icons.downloading_sharp),
//                 height: double.maxFinite,
//                 width: double.maxFinite,
//               ),
//             ),
//           ),
//
//         ],
//       ),
    );
  }
}

class MyDraggableScrollableSheet extends StatefulWidget {
  const MyDraggableScrollableSheet({super.key, required this.foodTruck});
  final FoodTruck foodTruck;
  @override
  State<MyDraggableScrollableSheet> createState() =>
      _MyDraggableScrollableSheetState();
}

class _MyDraggableScrollableSheetState
    extends State<MyDraggableScrollableSheet> {
  double _sheetPosition = 0.6;
  final double _dragSensitivity = 600;

  @override
  Widget build(BuildContext context) {
    final data = context.read<TruckMapViewModel>().menu;
    if (data == null) {
      return Container(
        child: const Center(
          child: Text("No data available"),
        ),
      );
    }
    return DraggableScrollableSheet(
      maxChildSize: 1,
      minChildSize: .6,
      initialChildSize: .6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(234, 224, 214, 1),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )),
          child: Column(
            children: <Widget>[
              Grabber(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _sheetPosition -= details.delta.dy / _dragSensitivity;
                    if (_sheetPosition < 0.25) {
                      _sheetPosition = 0.25;
                    }
                    if (_sheetPosition > 1.0) {
                      _sheetPosition = 1.0;
                    }
                  });
                },
                isOnDesktopAndWeb: _isOnDesktopAndWeb,
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: CustomScrollView(
                    controller: _isOnDesktopAndWeb ? null : scrollController,
                    slivers: [
                      SliverFillRemaining(
                        child: DefaultTabController(
                          length: data!.categories.length,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // controller:
                            //     _isOnDesktopAndWeb ? null : scrollController,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Center(
                                  child: Container(
                                    height: 5,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              TabBar(
                                tabs: data!.categories
                                    .map((e) => Tab(
                                          text: e.name,
                                        ))
                                    .toList(),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: data.categories.map((category) {
                                    return Center(
                                        child: ListView(
                                      children: category.items
                                          .map((e) => SizedBox(
                                                height: 100,

                                                child: Card(
                                                    elevation: 0,
                                                    color: const Color.fromRGBO(
                                                        246, 244, 239, 1.0),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100,height: 100,
                                                            decoration: const BoxDecoration(
                                                                // color: Colors.red,
                                                                // image: DecorationImage(
                                                                //     image: AssetImage(
                                                                //       "assets/images/food.jpeg",
                                                                //     ),),
                                                                ),
                                                            child: Image.asset(
                                                              'assets/images/food.jpeg',
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                e.title,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge,
                                                              ),
                                                              Text(
                                                                  "\$${e.price.toString()}"),
                                                              Spacer(),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                width: 100,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    border: Border
                                                                        .all()),
                                                                child:
                                                                    const Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Icon(Icons
                                                                        .close),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text("0"),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Icon(Icons
                                                                        .add),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ))
                                          .toList(),
                                    ));
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  // child: SingleChildScrollView(
                  //   controller: _isOnDesktopAndWeb ? null : scrollController,
                  //   child: Consumer<TruckMapViewModel>(
                  //     builder: (context, val, _) {
                  //       if (val.menu == null) return Container();
                  //       return SizedBox(
                  //         width: double.maxFinite,
                  //         child: DefaultTabController(
                  //           length: val.menu!.categories.length,
                  //           child: CustomScrollView(
                  //
                  //             // controller:
                  //             //     _isOnDesktopAndWeb ? null : scrollController,
                  //             slivers: [
                  //               SliverToBoxAdapter(
                  //                 child: TabBar(
                  //                   tabs: val.menu!.categories
                  //                       .map((e) => Tab(
                  //                             text: e.name,
                  //                           ))
                  //                       .toList(),
                  //                 ),
                  //               ),
                  //               SliverFillRemaining(
                  //                 child: TabBarView(
                  //
                  //                   children: val.menu!.categories.map(( tab) {
                  //                     return const Center(
                  //                       child: Text(
                  //                         'This is the el tab',
                  //                         style: TextStyle(fontSize: 36),
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: colorScheme.onSurface,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
