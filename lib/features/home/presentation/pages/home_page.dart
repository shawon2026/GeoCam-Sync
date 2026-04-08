import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_appbar.dart';
import '/core/presentation/widgets/global_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Home List'),
      body: const Center(child: GlobalText(str: 'Home  List')),
    );
  }
}
