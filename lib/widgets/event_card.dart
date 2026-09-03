import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../models/event.dart';
import '../utils/theme.dart';

class EventCard extends StatelessWidget {
  final Event event;

  /// Whether this card is being used in a registration
  /// event-selection section.
  final bool selectable;

  /// Whether this event is currently selected.
  final bool selected;

  /// Called when the event is selected.
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.selectable = false,
    this.selected = false,
    this.onTap,
  });

  // ==========================================================================
  // OPEN EVENT RULES IN NEW TAB
  // ==========================================================================

  void _openEvent() {
    final String eventPath = '/event/${event.slug}';

    final String fullUrl =
        '${web.window.location.origin}$eventPath';

    web.window.open(
      fullUrl,
      '_blank',
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),

      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFE9FCF9)
            : Colors.white,

        border: Border.all(
          color: selected
              ? AppTheme.teal
              : AppTheme.border,
          width: selected ? 2 : 1,
        ),

        borderRadius: BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Color(0x0B1A334D),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // RADIO / SELECTION
              // ==============================================================

              if (selectable)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                    top: 2,
                  ),
                  child: RadioGroup<bool>(
                    groupValue: selected ? true : null,

                    onChanged: (bool? value) {
                      if (value == true) {
                        onTap?.call();
                      }
                    },

                    child: const Radio<bool>(
                      value: true,
                      activeColor: AppTheme.teal,
                    ),
                  ),
                ),

              // ==============================================================
              // EVENT ICON
              // ==============================================================

              GestureDetector(
                behavior: HitTestBehavior.opaque,

                onTap: selectable
                    ? onTap
                    : null,

                child: Container(
                  width: 52,
                  height: 52,

                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5F9),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Text(
                    event.icon,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ==============================================================
              // EVENT INFORMATION
              // ==============================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    // --------------------------------------------------------
                    // CATEGORY
                    // --------------------------------------------------------

                    Text(
                      event.category.toUpperCase(),

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: AppTheme.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // --------------------------------------------------------
                    // EVENT NAME
                    // --------------------------------------------------------

                    Text(
                      event.name,

                      maxLines: 2,

                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // --------------------------------------------------------
                    // DESCRIPTION
                    // --------------------------------------------------------

                    Text(
                      event.description,

                      maxLines: 3,

                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ========================================================
                    // EXPLORE EVENT
                    // ========================================================

                    TextButton(
                      onPressed: _openEvent,

                      style: TextButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 6,
                        ),

                        minimumSize:
                        Size.zero,

                        tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap,

                        alignment:
                        Alignment.centerLeft,

                        foregroundColor:
                        AppTheme.teal,
                      ),

                      child: const Text(
                        'Explore Event →',

                        style: TextStyle(
                          color: AppTheme.teal,
                          fontWeight:
                          FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}