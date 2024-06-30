import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> launchGoogleMaps({
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {'q': '$destinationLatitude, $destinationLongitude'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;

    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  static double calculateDistance(LatLng start, LatLng end) {
    const R = 6371;
    final lat1 = start.latitude;
    final lon1 = start.longitude;
    final lat2 = end.latitude;
    final lon2 = end.longitude;
    final dLat = _degreeToRadian(lat2 - lat1);
    final dLon = _degreeToRadian(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(lat1)) *
            cos(_degreeToRadian(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * asin(sqrt(a));
    final distance = R * c;
    return distance;
  }

  static double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  static LatLng getCenterOfBounds(LatLngBounds bounds) {
    double centerLat =
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    double centerLng =
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
    return LatLng(centerLat, centerLng);
  }
}
