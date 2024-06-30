import 'dart:convert';

import 'package:app/app/truck_feature/data/models/menu/menu.dart';
import 'package:app/app/truck_feature/data/models/truck/truck_model.dart';
import 'package:app/app/truck_feature/domain/usecases/GetTrucksUsecase.dart';
import 'package:app/core/data/dio.dart';
import 'package:app/core/utils/results.dart';

abstract class TruckRemoteDataSource {
  ResultFuture<List<FoodTruckModel>> getTrucks(GetTrucksParams params);
  ResultFuture<FoodTruckMenuModel> getMenu(String params);
}

class TruckRemoteDataSourceImpl extends TruckRemoteDataSource {
  final ApiService _apiService;

  TruckRemoteDataSourceImpl(this._apiService);

  @override
  ResultFuture<List<FoodTruckModel>> getTrucks(GetTrucksParams params) {
    print("============");
    print(params.toJson());
    return _apiService.post('/truck/getinbounds', data: params.toJson(),
        mapFunction: (data) {
      final res = foodTruckFromJson(data);
      return res;
    });
  }

  @override
  ResultFuture<FoodTruckMenuModel> getMenu(String params) {
    return _apiService.get('/truck/menu/123', mapFunction: (data) {
      final res = foodTruckMenuFromJson(jsonEncode(data));
      return res;
    });
  }
}
