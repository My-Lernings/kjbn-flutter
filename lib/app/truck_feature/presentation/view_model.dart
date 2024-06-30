import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:app/app/truck_feature/domain/entities/menu/menu.dart';
import 'package:app/app/truck_feature/domain/usecases/GetMenuByIdUsease.dart';
import 'package:app/app/truck_feature/presentation/ui/map_view.dart';
import 'package:app/app/truck_feature/presentation/ui/single_truck_view.dart';
import 'package:app/core/location/locator.dart';
import 'package:app/core/utils/cupertino_sheet_route.dart';
import 'package:app/core/utils/map.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';

import 'package:app/core/assets/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/app/truck_feature/domain/entities/truck/truck_entity.dart';
import 'package:app/app/truck_feature/domain/repos/FoodTruckRepository.dart';
import 'package:app/app/truck_feature/domain/usecases/GetTrucksUsecase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/utils/messages/snackbar.dart';

class TruckMapViewModel extends ChangeNotifier {
  TruckMapViewModel({required FoodTruckRepository repository})
      : _repository = repository;
  final FoodTruckRepository _repository;

  GoogleMapController? _googleMapController;
  GoogleMapController? get googleMapController => _googleMapController;
  set setGoogleMapController(GoogleMapController v) {
    _googleMapController = v;
    notifyListeners();
    if (position == null) {
      getPosition().then((value) {
        _googleMapController?.getVisibleRegion().then((value) {
          getData(value);
        });
      });
    } else {
      _googleMapController?.getVisibleRegion().then((value) {
        getData(value);
      });
    }
  }

  Position? _position;
  Position? get position => _position;
  set setPosition(Position v) {
    _position = v;
    notifyListeners();
  }

  Future<void> getPosition() async {
    try {
      final pos = await determinePosition();
      setPosition = pos;
      _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(pos.latitude, pos.longitude))));
    } catch (e) {
      showAMessage(e.toString());
    }
  }

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  set setMarkers(Set<Marker> v) {
    _markers = v;
    notifyListeners();
  }

  void addToMarkers(Set<Marker> v) {
    _markers = {...markers, ...v};
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setIsLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  bool _boundMoved = false;
  bool get boundMoved => _boundMoved;
  set setIsBoundMoved(bool v) {
    _boundMoved = v;
    notifyListeners();
  }
  // 100.20.92.101
  // 44.225.181.72
  // 44.227.217.144
  List<FoodTruck> list = [];
  Future<void> getData(LatLngBounds params) async {
    if (_isLoading) return;
    setIsLoading = true;
    final res = await GetTrucksUseCase(repository: _repository).call(
        GetTrucksParams(
            minLat: params.northeast.latitude,
            minLong: params.northeast.longitude,
            maxLat: params.southwest.latitude,
            maxLong: params.southwest.longitude));
    res.fold((l) {
      setIsLoading = false;
      showAMessage(l.message);
    }, (r) async {
      setIsLoading = false;
      _boundMoved = false;
      list = r;
      await _createMarkers(r).then((value) {
        setMarkers = value;
        notifyListeners();
      });
      googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(
          MapUtils.boundsFromLatLngList(r
              .map((e) =>
                  LatLng(e.location.coordinates[1], e.location.coordinates[0]))
              .toList()),
          4));
    });
  }

  FoodTruckMenu? _menu;
  FoodTruckMenu? get menu => _menu;
  set setFoodTruckMenu(FoodTruckMenu v) {
    _menu = v;
    notifyListeners();
  }

  Future<void> getMenu(String id) async {
    final caller = GetMenuByIdUseCase(repository: _repository);
    setIsLoading = true;
    final res = await caller.call('123');
    res.fold((l) {
      setIsLoading = false;
    }, (r) {
      setFoodTruckMenu = r;
      setIsLoading = false;
    });
  }
  //////

  Future<Set<Marker>> _createMarkers(List<FoodTruck> r) async {
    final BitmapDescriptor icon = await MyIcons.loadMarker();

    final Set<Marker> markers = {};
    markers.addAll(r.map((e) => _createMarkerFromTruck(e, icon)).toList());
    return markers;
  }

  Marker _createMarkerFromTruck(FoodTruck e, BitmapDescriptor icon) {
    return Marker(
        icon: icon,
        // icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
            onTap: () {
              if (scaffoldKey.currentContext == null) return;
              getMenu(e.id);
              CupertinoScaffoldRoutes.pushCupertinoSheetRoute(
                  scaffoldKey.currentContext!,
                  route: SingleTruckView(
                    data: e,
                  ));
            },
            title: e.applicant,
            snippet: e.locationdescription),
        position: LatLng(e.location.coordinates[1], e.location.coordinates[0]),
        markerId: MarkerId(e.id));
  }

  void onPointerMove() {
    _checkCameraMovement();
  }

  LatLngBounds? _previousBounds;
  void _checkCameraMovement() async {
    if (_googleMapController == null) return;
    LatLngBounds bounds = await _googleMapController!.getVisibleRegion();
    if (_previousBounds != null) {
      LatLng previousCenter = _getCenter(_previousBounds!);
      LatLng currentCenter = _getCenter(bounds);

      double distance = _calculateDistance(previousCenter, currentCenter);

      double halfWidth = (_previousBounds!.northeast.longitude -
              _previousBounds!.southwest.longitude) /
          2;
      double halfHeight = (_previousBounds!.northeast.latitude -
              _previousBounds!.southwest.latitude) /
          2;

      if (distance > halfWidth || distance > halfHeight) {
        print('Camera view has moved more than half of its previous position.');
      }
    }
    _previousBounds = bounds;
  }

  LatLng _getCenter(LatLngBounds bounds) {
    double centerLat =
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    double centerLng =
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
    return LatLng(centerLat, centerLng);
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // in meters

    double dLat = _degreesToRadians(point2.latitude - point1.latitude);
    double dLng = _degreesToRadians(point2.longitude - point1.longitude);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(point1.latitude)) *
            cos(_degreesToRadians(point2.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

//37.7713221,-122.4333159
