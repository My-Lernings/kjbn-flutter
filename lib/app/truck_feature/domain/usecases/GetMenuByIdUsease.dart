import 'package:app/app/truck_feature/domain/entities/menu/menu.dart';
import 'package:app/app/truck_feature/domain/repos/FoodTruckRepository.dart';
import 'package:app/core/usecase/base_usecase.dart';
import 'package:app/core/utils/results.dart';

class GetMenuByIdUseCase extends UseCaseWithParams<FoodTruckMenu,String>{
  final FoodTruckRepository _repository;

  GetMenuByIdUseCase({required FoodTruckRepository repository}) : _repository = repository;

  @override
  ResultFuture<FoodTruckMenu> call(String params) async{
    return await _repository.getMenuById(params);
  }
}