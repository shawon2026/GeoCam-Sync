import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/theme/app_colors.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.erroMsg});

  final List<dynamic> erroMsg;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GlobalText(
                str: "Error",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.btnText.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 16.w),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                erroMsg.length,
                (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 20.w),
                        child: GlobalText(
                          str: erroMsg[index]
                              .toString()
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.btnText.color,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
