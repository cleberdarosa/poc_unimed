import 'package:flutter/material.dart';

import '../../core/theme/design_system.dart';
import 'widgets/home_footer.dart';
import 'widgets/home_header.dart';
import 'widgets/mini_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const HomeFooter(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DS.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SizedBox(height: DS.spaceXl),

              const MiniCard(),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
