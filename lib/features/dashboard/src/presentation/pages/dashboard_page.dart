// Role: Dashboard page composed from smaller widgets (header/cards/chart/bottom-nav).
import 'package:flutter/material.dart';

import '../widgets/dashboard_bottom_nav.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/spending_comparison_card.dart';
import '../widgets/spending_overview_card.dart';
import '../widgets/total_assets_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming Step 1/2 already wired tokens into Theme via DS.
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surface; // should map to background-main

    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          const SliverPersistentHeader(
            pinned: true,
            delegate: _DashboardHeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TotalAssetsCard(),
                  const SizedBox(height: 24),
                  const SpendingOverviewCard(),
                  const SizedBox(height: 24),
                  const SpendingComparisonCard(),
                  const SizedBox(height: 120), // space for bottom nav overlay
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DashboardBottomNav(activeIndex: 0),
    );
  }
}

class _DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _DashboardHeaderDelegate();

  @override
  double get minExtent => 92;

  @override
  double get maxExtent => 92;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const DashboardHeader();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
