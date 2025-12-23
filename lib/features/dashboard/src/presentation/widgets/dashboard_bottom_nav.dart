// Role: Bottom navigation with center add button (floating) like HTML.
import 'dart:ui';
import 'package:flutter/material.dart';

// TODO: Replace with your actual DS import path.
import 'package:paylance/core/design_system/design_system.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key, required this.activeIndex});

  final int activeIndex; // 0: Tổng quan, 1: Lịch sử, 2: Kế hoạch, 3: Khác

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surface;
    final primary = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurfaceVariant;
    final on = theme.colorScheme.onSurface;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 22),
          decoration: BoxDecoration(
            color: bg.withOpacity(0.95),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
          ),
          child: SizedBox(
            height: 64,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -28,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _AddButton(primary: primary, bg: bg),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _NavItem(
                            label: 'Tổng quan',
                            icon: Icons.grid_view_rounded,
                            active: activeIndex == 0,
                          ),
                          const SizedBox(width: 28),
                          _NavItem(
                            label: 'Lịch sử',
                            icon: Icons.history,
                            active: activeIndex == 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _NavItem(
                            label: 'Kế hoạch',
                            icon: Icons.savings_outlined,
                            active: activeIndex == 2,
                          ),
                          const SizedBox(width: 28),
                          _NavItem(
                            label: 'Khác',
                            icon: Icons.more_horiz,
                            active: activeIndex == 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.primary, required this.bg});

  final Color primary;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Thêm giao dịch',
      child: InkResponse(
        onTap: () {},
        radius: 34,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.40),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(Icons.add, size: 32, color: bg),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
  });

  final String label;
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurfaceVariant;

    final color = active ? primary : muted.withOpacity(0.60);
    final weight = active ? FontWeight.w800 : FontWeight.w700;

    return InkResponse(
      onTap: () {},
      child: SizedBox(
        width: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: weight,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
