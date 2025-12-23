// Role: Sticky header (avatar + greeting + notification icon with badge).
import 'dart:ui';
import 'package:flutter/material.dart';

// TODO: Replace with your actual DS import path.
import 'package:paylance/core/design_system/design_system.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surface;
    final card = theme.colorScheme.surfaceContainerHighest;
    final primary = theme.colorScheme.primary;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: bg.withOpacity(0.95),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                _AvatarWithStatus(
                  primary: primary,
                  borderColor: primary,
                  bg: bg,
                ),
                const SizedBox(width: 12),
                const Expanded(child: _GreetingBlock()),
                const SizedBox(width: 12),
                _NotificationButton(cardColor: card),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({
    required this.primary,
    required this.borderColor,
    required this.bg,
  });

  final Color primary;
  final Color borderColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            image: const DecorationImage(
              // Same as HTML: background-image avatar
              image: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDh7rpo5Ctr10J6TwOSGb6uGRVqA2qDENvZyVRzdaVnBHQ9LSKl08aZ_Mc4Ncqkx4EY68DfKa_ZTDt5wwP2YExNek0QkX7d0my76OP-oLklPlk3TFEWYEqz3OdQ0AMg8E5mrgBS3gt5NImOmr2Dfq7opvCTNEu10plthvJthQa2XGDuEaz3xNLaStMpnb3Ye7ZZUva9v00vCQ_jTODOFU72SRU-NdNMchoZswXS3gxzcc9CSZ-9pYUZxQG08XIhv7cqAH3yWdpEuVg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
              border: Border.all(color: bg, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _GreetingBlock extends StatelessWidget {
  const _GreetingBlock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final on = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chào buổi sáng',
          style: theme.textTheme.labelSmall?.copyWith(
            color: muted,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Minh Nguyễn',
          style: theme.textTheme.titleMedium?.copyWith(
            color: on,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.cardColor});

  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return Semantics(
      label: 'Thông báo',
      child: InkResponse(
        onTap: () {},
        radius: 26,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(0.18),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(child: Icon(Icons.notifications_outlined, color: on)),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    shape: BoxShape.circle,
                    border: Border.all(color: cardColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
