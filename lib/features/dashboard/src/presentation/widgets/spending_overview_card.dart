// Role: "Tình hình chi tiêu" card with stats grid + progress + message.
import 'package:flutter/material.dart';

// TODO: Replace with your actual DS import path.
import 'package:paylance/core/design_system/design_system.dart';

class SpendingOverviewCard extends StatelessWidget {
  const SpendingOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = theme.colorScheme.surfaceContainerHighest;
    final on = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(
                'Tình hình chi tiêu',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: on,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              InkResponse(
                onTap: () {},
                child: Text(
                  'Chi tiết',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _StatsRow(
                spentLabel: 'Đã chi',
                spentValue: '3.000.000',
                budgetLabel: 'Ngân sách',
                budgetValue: '10.000.000',
                remainingLabel: 'Còn lại',
                remainingValue: '7.000.000',
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: on,
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        const TextSpan(text: '30'),
                        TextSpan(
                          text: '%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Tháng 10/2023',
                    style: theme.textTheme.labelSmall?.copyWith(color: muted),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _ProgressBar(value: 0.30, primary: primary),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bạn đang chi tiêu rất tốt! Tiếp tục duy trì nhé.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: muted,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.spentLabel,
    required this.spentValue,
    required this.budgetLabel,
    required this.budgetValue,
    required this.remainingLabel,
    required this.remainingValue,
  });

  final String spentLabel;
  final String spentValue;
  final String budgetLabel;
  final String budgetValue;
  final String remainingLabel;
  final String remainingValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    final primary = theme.colorScheme.primary;

    Widget item({
      required String label,
      required String value,
      required Color valueColor,
      EdgeInsetsGeometry? padding,
      bool showDivider = false,
    }) {
      return Expanded(
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: label == 'Còn lại' ? primary : muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        item(
          label: spentLabel,
          value: spentValue,
          valueColor: on,
          padding: const EdgeInsets.only(right: 12),
        ),
        Container(width: 1, height: 34, color: Colors.white.withOpacity(0.10)),
        item(
          label: budgetLabel,
          value: budgetValue,
          valueColor: on,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        Container(width: 1, height: 34, color: Colors.white.withOpacity(0.10)),
        item(
          label: remainingLabel,
          value: remainingValue,
          valueColor: primary,
          padding: const EdgeInsets.only(left: 12),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.primary});

  final double value;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 12,
        color: Colors.white.withOpacity(0.05),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(color: primary.withOpacity(0.50), blurRadius: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
