// Role: "So sánh thu chi" card with segmented toggle + chart + legend.
import 'package:flutter/material.dart';

// TODO: Replace with your actual DS import path.
import 'package:paylance/core/design_system/design_system.dart';

import 'spending_comparison_chart.dart';

class SpendingComparisonCard extends StatefulWidget {
  const SpendingComparisonCard({super.key});

  @override
  State<SpendingComparisonCard> createState() => _SpendingComparisonCardState();
}

class _SpendingComparisonCardState extends State<SpendingComparisonCard> {
  int _tab = 0; // 0: Chi tiêu, 1: Thu nhập

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = theme.colorScheme.surfaceContainerHighest;
    final bg = theme.colorScheme.surface;
    final on = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'So sánh thu chi',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: on,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _SegButton(
                        label: 'Chi tiêu',
                        selected: _tab == 0,
                        onTap: () => setState(() => _tab = 0),
                      ),
                      _SegButton(
                        label: 'Thu nhập',
                        selected: _tab == 1,
                        onTap: () => setState(() => _tab = 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SizedBox(
              height: 192, // ~ h-48
              child: SpendingComparisonChart(),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _AxisLabel('1'),
                  _AxisLabel('5'),
                  _AxisLabel('10'),
                  _AxisLabel('15'),
                  _AxisLabel('20'),
                  _AxisLabel('25'),
                  _AxisLabel('30'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(solid: true, label: 'Tháng này'),
                const SizedBox(width: 18),
                _LegendItem(solid: false, label: 'Tháng trước'),
              ],
            ),
            // Keep muted text style consistent with HTML's mono labels, handled inside painter.
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  const _SegButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bg = theme.colorScheme.surface;
    final muted = theme.colorScheme.onSurfaceVariant;

    return InkResponse(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: selected ? bg : muted,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AxisLabel extends StatelessWidget {
  const _AxisLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: muted,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.solid, required this.label});

  final bool solid;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Container(
          width: 14,
          height: 4,
          decoration: BoxDecoration(
            color: solid ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(99),
            border: solid
                ? null
                : Border(
                    top: BorderSide(
                      color: muted,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
