import 'package:app/app/truck_feature/domain/usecases/GetTrucksUsecase.dart';
import 'package:app/app/truck_feature/presentation/ui/truck_list_view.dart';
import 'package:app/core/utils/cupertino_sheet_route.dart';
import 'package:app/core/utils/map.dart';
import 'package:dev/dev.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/app/truck_feature/presentation/view_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MapView extends StatelessWidget {
  const MapView({super.key});
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.7713221, -122.4333159),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    final watcher = context.watch<TruckMapViewModel>();
    watcher.addListener(() {
      if (watcher.list.isNotEmpty) {}
    });
    return Consumer<TruckMapViewModel>(builder: (context, val, _) {
      return CupertinoScaffold(
        body: Builder(builder: (context) {
          return CupertinoPageScaffold(
            child: Scaffold(
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton.extended(
                icon: Icon(Icons.menu),
                onPressed: () async {
                  CupertinoScaffoldRoutes.pushCupertinoSheetRoute(context,
                      route: TruckListView());
                },
                label: Text("List"),
              ),
              body: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Listener(
                      onPointerMove: (move) async {
                        val.onPointerMove();
                        val.setIsBoundMoved = true;
                      },
                      child: GoogleMap(
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          markers: val.markers,
                          onMapCreated: (controller) {
                            val.setGoogleMapController = controller;
                          },
                          initialCameraPosition: _kGooglePlex),
                    ),
                  ),
                  if (val.boundMoved)
                    AnimatedPositioned(
                      top: val.boundMoved ? 10 : -10,
                      left: 0,
                      right: 0,
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SafeArea(
                            child: GestureDetector(
                              onTap: () {
                                val.googleMapController
                                    ?.getVisibleRegion()
                                    .then((value) {
                                  val.getData(value);
                                });
                              },
                              child: Card(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width: 150,
                                    height: 30,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.search),
                                        Text("Search this area"),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if(val.isLoading)
                  Container(
                    color: Colors.grey.withOpacity(.3),
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}
