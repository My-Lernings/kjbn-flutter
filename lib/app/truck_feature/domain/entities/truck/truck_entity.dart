import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class FoodTruck extends Equatable{
  final String id;
  final String objectid;
  final String applicant;
  final String cnn;
  final String locationdescription;
  final String address;
  final String permit;
  final String status;
  final String latitude;
  final String longitude;
  final String schedule;
  final String received;
  final String priorpermit;
  final Location location;

  const FoodTruck({
    required this.id,
    required this.objectid,
    required this.applicant,
    required this.cnn,
    required this.locationdescription,
    required this.address,
    required this.permit,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.schedule,
    required this.received,
    required this.priorpermit,
    required this.location,
  });

  @override
  List<Object?> get props => [id];

}

class Location extends Equatable{
 final String type;
 final List<double> coordinates;

  const Location({
    required this.type,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [];

}
