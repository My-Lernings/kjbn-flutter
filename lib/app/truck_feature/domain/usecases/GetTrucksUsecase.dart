import 'package:app/app/truck_feature/domain/entities/truck/truck_entity.dart';
import 'package:app/app/truck_feature/domain/repos/FoodTruckRepository.dart';
import 'package:app/core/usecase/base_usecase.dart';
import 'package:app/core/utils/results.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetTrucksUseCase
    extends UseCaseWithParams<List<FoodTruck>, GetTrucksParams> {
  final FoodTruckRepository _repository;

  GetTrucksUseCase({required FoodTruckRepository repository})
      : _repository = repository;
  @override
  ResultFuture<List<FoodTruck>> call(GetTrucksParams params) async {
    return await _repository.getFoodTrucks(params);
  }
}

class GetTrucksParams {
  final double minLat;
  final double minLong;
  final double maxLat;
  final double maxLong;

  GetTrucksParams(
      {required this.minLat,
      required this.minLong,
      required this.maxLat,
      required this.maxLong});

  Map<String, dynamic> toJson() {
    return {
      'minlat': minLat,
      'minlon': minLong,
      'maxlat': maxLat,
      'maxlon': maxLong
    };
  }
}
