import 'package:app/app/truck_feature/domain/entities/truck/truck_entity.dart';
import 'package:app/app/truck_feature/presentation/ui/single_truck_view.dart';
import 'package:app/app/truck_feature/presentation/view_model.dart';
import 'package:app/core/utils/cupertino_sheet_route.dart';
import 'package:app/core/utils/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class TruckListView extends StatelessWidget {
  TruckListView({super.key});
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<TruckMapViewModel>(builder: (context, val, _) {
      return CupertinoScaffold(
        body: Builder(
          builder: (context) {
            return CupertinoPageScaffold(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("List of trucks in San Fransisco"),
                ),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: AnimatedList(
                      key: listKey,
                      initialItemCount: val.list.length,
                      itemBuilder: (context, index, animation) {
                        final FoodTruck item = val.list[index];
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, (10 * index).toDouble()),
                            end: Offset(0, 0),
                          ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.bounceIn,
                              reverseCurve: Curves.bounceOut)),
                          child: SizedBox(
                            height: 128.0,
                            child: ListTile(
                              onTap: () {
                                val.  getMenu(item.id);
                                CupertinoScaffoldRoutes.pushCupertinoSheetRoute(
                                   context,
                                    route: SingleTruckView(
                                      data: item,
                                    ));
                              },
                              title: Text(item.applicant),
                              leading: Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://www.partyone.in/suploads/2024/Feb/05/34408/1707118405weeding_food_truck.png"))),
                              ),
                              subtitle: Text(item.locationdescription),
                              trailing: GestureDetector(
                                  onTap: () {
                                    MapUtils.launchGoogleMaps(
                                        destinationLatitude:
                                            item.location.coordinates[1],
                                        destinationLongitude:
                                            item.location.coordinates[0]);
                                  },
                                  child: Icon(Icons.directions)),
                            ),
                          ),
                        ); // Refer step 3
                      },
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      );
    });
  }
}
