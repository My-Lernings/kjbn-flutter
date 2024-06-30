import 'package:app/app/truck_feature/domain/entities/menu/menu.dart';
import 'package:app/app/truck_feature/domain/entities/truck/truck_entity.dart';
import 'package:app/app/truck_feature/domain/usecases/GetTrucksUsecase.dart';
import 'package:app/core/utils/results.dart';

abstract  class FoodTruckRepository {
  ResultFuture<List<FoodTruck>> getFoodTrucks(GetTrucksParams params);
  ResultFuture<FoodTruckMenu> getMenuById(String id);
}