import 'package:app/app/truck_feature/data/data_source/trucks_remote_data.dart';
import 'package:app/app/truck_feature/data/models/menu/menu.dart';
import 'package:app/app/truck_feature/domain/entities/menu/menu.dart';
import 'package:app/app/truck_feature/domain/entities/truck/truck_entity.dart';
import 'package:app/app/truck_feature/domain/repos/FoodTruckRepository.dart';
import 'package:app/app/truck_feature/domain/usecases/GetTrucksUsecase.dart';
import 'package:app/core/utils/results.dart';

class FoodTruckRepositoryImpl extends FoodTruckRepository {
  final TruckRemoteDataSource _remoteDataSource;

  FoodTruckRepositoryImpl({required TruckRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;
  @override
  ResultFuture<List<FoodTruck>> getFoodTrucks(GetTrucksParams params) {
    return _remoteDataSource.getTrucks(params);
  }

  @override
  ResultFuture<FoodTruckMenuModel> getMenuById(String id) {
     return _remoteDataSource.getMenu(id);
  }
}
