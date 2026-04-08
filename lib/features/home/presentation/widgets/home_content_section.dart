import 'package:flutter/material.dart';
import '/core/routes/app_routes.dart';
import '/core/routes/navigation.dart';
import '/core/utils/extension.dart';
import '/features/home/presentation/widgets/home_navigation_card.dart';

class HomeContentSection extends StatelessWidget {
  const HomeContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeNavigationCard(
          title: context.loc.geoFencedAttendanceTitle,
          subtitle: context.loc.geoFencedAttendanceSubtitle,
          icon: Icons.location_on_outlined,
          buttonLabel: context.loc.openTask1Button,
          accentColor: const Color(0xFF0EA5E9),
          onTap: () =>
              Navigation.push(context, appRoutes: AppRoutes.attendance),
        ),
        const SizedBox(height: 12),
        HomeNavigationCard(
          title: context.loc.uploadManagerTitle,
          subtitle: context.loc.uploadManagerSubtitle,
          icon: Icons.cloud_upload_outlined,
          buttonLabel: context.loc.openTask2Button,
          accentColor: const Color(0xFF10B981),
          onTap: () =>
              Navigation.push(context, appRoutes: AppRoutes.uploadManager),
        ),
      ],
    );
  }
}
