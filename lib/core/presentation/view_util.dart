import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes/navigation.dart';
import '../theme/app_colors.dart';

class ViewUtil {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
    String msg, {
    String? btnName,
    void Function()? onPressed,
    BuildContext? context,
  }) {
    return ScaffoldMessenger.of(
      context ?? Navigation.key.currentContext!,
    ).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: GlobalText(
          str: msg,
          fontWeight: FontWeight.w500,
          color: AppColors.white.color,
        ),
        action: SnackBarAction(
          label: btnName ?? '',
          textColor: btnName == null
              ? Colors.transparent
              : AppColors.white.color,
          onPressed: onPressed ?? () {},
        ),
      ),
    );
  }

  // global alert dialog
  static Future<void> alertDialog({
    Widget? title,
    required Widget content,
    List<Widget>? actions,
    Color? alertBackgroundColor,
    bool? barrierDismissible,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    BuildContext? context,
  }) async {
    // flutter defined function.
    await showDialog(
      context: context ?? Navigation.key.currentContext!,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        // return object of type Dialog.
        return AlertDialog(
          backgroundColor: alertBackgroundColor ?? Colors.transparent,
          contentPadding:
              contentPadding ?? EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.all(Radius.circular(8.w)),
          ),
          title: title,
          content: content,
        );
      },
    );
  }

  static Future<dynamic> bottomSheet({
    required BuildContext context,
    bool? isDismissable,
    required Widget content,
    BoxConstraints? boxConstraints,
  }) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: boxConstraints,
      isScrollControlled: true,
      context: context,
      isDismissible: isDismissable ?? true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1a000000),
              offset: const Offset(0, 1),
              blurRadius: 3.r,
              spreadRadius: 0,
            ),
          ],
          color: const Color(0xffffffff),
        ),
        child: content,
      ),
    );
  }

  static Future<void> showLoader(BuildContext context) {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (dialogContext) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: SizedBox(
              height: 56,
              width: 56,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(12),
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
