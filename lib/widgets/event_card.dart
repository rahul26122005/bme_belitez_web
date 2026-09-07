import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/theme.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool selectable;
  final bool selected;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.selectable = false,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final child = width < 430
            ? _buildNarrow(context, width)
            : _buildWide(context, width);

        if (onTap == null) return child;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: child,
          ),
        );
      },
    );
  }

  BoxDecoration get _decoration => BoxDecoration(
        color: selected ? const Color(0xFFEAFBF8) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? AppTheme.teal : AppTheme.border,
          width: selected ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 4),
            color: Color(0x0A000000),
          ),
        ],
      );

  Widget _buildNarrow(BuildContext context, double width) {
    final tiny = width < 340;
    final iconSize = tiny ? 46.0 : 54.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tiny ? 10 : 12),
      decoration: _decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectable) ...[
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 22,
                  color: selected ? AppTheme.teal : AppTheme.muted,
                ),
                const SizedBox(width: 7),
              ],
              Container(
                width: iconSize,
                height: iconSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5F9),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  event.icon,
                  style: TextStyle(fontSize: tiny ? 22 : 27),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  event.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: tiny ? 15 : 16,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            event.category.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.blue,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            event.description,
            maxLines: tiny ? 3 : 4,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: const TextStyle(
              color: AppTheme.muted,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/event/${event.slug}',
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 5),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: const Text(
                'Explore Event →',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.teal,
                  fontWeight: FontWeight.w900,
                  fontSize: 11.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWide(BuildContext context, double width) {
    final iconSize = width < 600 ? 50.0 : 54.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _decoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectable) ...[
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 23,
              color: selected ? AppTheme.teal : AppTheme.muted,
            ),
            const SizedBox(width: 7),
          ],
          Container(
            width: iconSize,
            height: iconSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5F9),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(event.icon, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.category.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.blue,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    height: 1.18,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  event.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 11.5,
                    height: 1.32,
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/event/${event.slug}',
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                  child: const Text(
                    'Explore Event →',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.teal,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
