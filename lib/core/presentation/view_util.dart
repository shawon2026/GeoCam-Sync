import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewUtil {
  static Future<void> showLoader(BuildContext context) {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Center(
            child: SizedBox(
              height: 56.h,
              width: 56.w,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoader(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}
