
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as mbs;

class CupertinoScaffoldRoutes {
  static Future<dynamic> pushCupertinoSheetRoute(BuildContext context,
      {required Widget route,
        bool isDismissible = true,
        bool enableDrag = true,
        bool canPop = true,
        WillPopCallback? onWillPop}) async {
    return mbs.CupertinoScaffold.showCupertinoModalBottomSheet(
      enableDrag: enableDrag,
      overlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.black),
      expand: false,
      isDismissible: isDismissible,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WillPopScope(
          onWillPop: onWillPop ??
                  () async {
                return canPop;
              },
          child: route),
    );
  }
}

