import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class MyIcons {
  static String marker = 'assets/icons/marker.png';

  static BitmapDescriptor? loadedIcon;
  static Future<BitmapDescriptor> loadMarker() async {
    return MyIcons.loadedIcon ??
        await getBitmapDescriptorFromAsset('assets/icons/marker.png', 75);
  }

  static Future<BitmapDescriptor> getBitmapDescriptorFromAsset(
      String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List list = data.buffer.asUint8List();

    final ui.Codec codec =
        await ui.instantiateImageCodec(list, targetWidth: width);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    final res = BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    return res;
  }
}
