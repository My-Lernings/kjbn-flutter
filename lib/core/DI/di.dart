import 'dart:async';

import 'package:app/app/truck_feature/data/data_source/trucks_remote_data.dart';
import 'package:app/app/truck_feature/data/repos/food_truck_repo_impl.dart';
import 'package:app/app/truck_feature/domain/repos/FoodTruckRepository.dart';
import 'package:app/core/data/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async{

  getIt.registerLazySingleton<TruckRemoteDataSource>(
      () => TruckRemoteDataSourceImpl(ApiService.main()));

  getIt.registerLazySingleton<FoodTruckRepository>(() =>
      FoodTruckRepositoryImpl(
          remoteDataSource: getIt<TruckRemoteDataSource>()));


}
