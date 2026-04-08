import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

class Widget extends StatelessWidget {
  const Widget({super.key});

  @override
  Center build(BuildContext context) {
    return const Center(child: GlobalText(str: 'Widget'));
  }
}
