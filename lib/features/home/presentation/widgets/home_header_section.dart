import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F766E), Color(0xFF115E59)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            str: context.loc.homeNavigationHubTitle,
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 8),
          GlobalText(
            str: context.loc.homeNavigationHubSubtitle,
            color: Color(0xFFE6FFFB),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ],
      ),
    );
  }
}
