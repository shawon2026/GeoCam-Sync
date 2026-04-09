import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_appbar.dart';
import '/core/utils/extension.dart';
import '/features/home/presentation/widgets/home_content_section.dart';
import '/features/home/presentation/widgets/home_header_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(title: context.loc.homeAppTitle, centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeaderSection(),
              SizedBox(height: 16.h),
              HomeContentSection(),
            ],
          ),
        ),
      ),
    );
  }
}
