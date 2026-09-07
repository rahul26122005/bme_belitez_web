import 'package:flutter/material.dart';

import 'event.dart';
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

        // A vertical layout on narrow phones completely removes the
        // common RenderFlex horizontal-overflow problem.
        if (width < 430) {
          return _mobileCard(context, width);
        }

        return _wideCard(context, width);
      },
    );
  }

  Widget _mobileCard(BuildContext context, double width) {
    final compact = width < 360;
    final horizontal = compact ? 12.0 : 14.0;
    final iconSize = compact ? 50.0 : 56.0;

    final content = Container(
      width: double.infinity,
      padding: EdgeInsets.all(horizontal),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (selectable) ...[
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: compact ? 23 : 25,
                  color: selected
                      ? AppTheme.teal
                      : const Color(0xFF263238),
                ),
                const SizedBox(width: 9),
              ],
              Container(
                width: iconSize,
                height: iconSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  event.icon,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: compact ? 25 : 28),
                ),
              ),
              const Spacer(),
              if (selectable)
                Icon(
                  selected
                      ? Icons.check_circle
                      : Icons.arrow_forward_ios,
                  size: 17,
                  color: selected
                      ? AppTheme.teal
                      : const Color(0xFF9AA7B2),
                ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            event.category.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF5267D9),
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: Colors.black,
              fontSize: compact ? 17 : 18,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            event.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: AppTheme.muted,
              fontSize: compact ? 11 : 12,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    return _tapWrapper(content);
  }

  Widget _wideCard(BuildContext context, double width) {
    final compact = width < 560;
    final iconSize = compact ? 54.0 : 62.0;

    final content = Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: _decoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (selectable) ...[
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: compact ? 24 : 27,
              color: selected
                  ? AppTheme.teal
                  : const Color(0xFF263238),
            ),
            const SizedBox(width: 9),
          ],
          Container(
            width: iconSize,
            height: iconSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              event.icon,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: compact ? 27 : 31),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.category.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF5267D9),
                    fontSize: compact ? 9 : 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .9,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: compact ? 16.5 : 18,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  event.description,
                  maxLines: compact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontSize: compact ? 11 : 12,
                    height: 1.28,
                  ),
                ),
              ],
            ),
          ),
          if (selectable) ...[
            const SizedBox(width: 9),
            Icon(
              selected
                  ? Icons.check_circle
                  : Icons.arrow_forward_ios,
              size: 16,
              color: selected
                  ? AppTheme.teal
                  : const Color(0xFF9AA7B2),
            ),
          ],
        ],
      ),
    );

    return _tapWrapper(content);
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: selected ? const Color(0xFFF0FFFC) : Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(
        color: selected ? AppTheme.teal : const Color(0xFFDCE4EA),
        width: selected ? 2 : 1.2,
      ),
      boxShadow: const [
        BoxShadow(
          blurRadius: 9,
          offset: Offset(0, 3),
          color: Color(0x0A000000),
        ),
      ],
    );
  }

  Widget _tapWrapper(Widget child) {
    if (onTap == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: child,
      ),
    );
  }
}
