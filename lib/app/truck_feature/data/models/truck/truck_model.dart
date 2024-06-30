import 'dart:convert';

import 'package:app/app/truck_feature/domain/entities/truck/truck_entity.dart';
List<FoodTruckModel> foodTruckFromJson(List<dynamic> data) => data.map((e) => FoodTruckModel.fromJson(e)).toList();



class FoodTruckModel extends FoodTruck {
  const FoodTruckModel({
    required super.id,
    required super.objectid,
    required super.applicant,
    required super.cnn,
    required super.locationdescription,
    required super.address,
    required super.permit,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.schedule,
    required super.received,
    required super.priorpermit,
    required super.location,
  });

  factory FoodTruckModel.fromJson(Map<String, dynamic> json) => FoodTruckModel(
        id: json["_id"] ?? '',
        objectid: json["objectid"]?? '',
        applicant: json["applicant"]?? '',
        cnn: json["cnn"]?? '',
        locationdescription: json["locationdescription"]?? '',
        address: json["address"]?? '',
        permit: json["permit"]?? '',
        status: json["status"]?? '',
        latitude: json["latitude"]?? '',
        longitude: json["longitude"]?? '',
        schedule: json["schedule"]?? '',
        received: json["received"]?? '',
        priorpermit: json["priorpermit"]?? '',
        location:json["location"] !=null ? LocationModel.fromJson(json["location"]) : const Location(type: '', coordinates: []),
      );
}

class LocationModel extends Location {
  const LocationModel({
    required super.type,
    required super.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        type: json["type"]?? '',
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );
}
