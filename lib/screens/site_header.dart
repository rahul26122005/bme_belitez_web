import 'package:flutter/material.dart';
import '../utils/theme.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;

  const SiteHeader({
    super.key,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.navy,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 78,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              if (width < 760) {
                return _mobileHeader(context, width);
              }

              return _desktopHeader(context, width);
            },
          ),
        ),
      ),
    );
  }

  Widget _mobileHeader(BuildContext context, double width) {
    final verySmall = width < 360;
    final logoSize = verySmall ? 42.0 : 48.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: verySmall ? 7 : 10,
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          if (showBack) const SizedBox(width: 3),
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/biomedical-logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.biotech,
                color: AppTheme.navy,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _brandText(
              small: verySmall,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Menu',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 42,
            ),
            onPressed: () => _showMenu(context),
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopHeader(BuildContext context, double width) {
    final compact = width < 1000;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              if (showBack)
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              if (showBack) const SizedBox(width: 4),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.all(3),
                child: Image.asset(
                  'assets/images/biomedical-logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.biotech,
                    color: AppTheme.navy,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _brandText(small: compact),
              ),
              const SizedBox(width: 8),
              if (!compact) ...[
                _nav(context, 'Department', '/'),
                _nav(context, "B'ELITEZ 2K26", '/events'),
                _nav(context, 'Events', '/events'),
                const SizedBox(width: 5),
              ],
              FilledButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/register',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.teal,
                  foregroundColor: AppTheme.dark,
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 13 : 18,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (compact) ...[
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'Menu',
                  onPressed: () => _showMenu(context),
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandText({required bool small}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MAHENDRA COLLEGE OF ENGINEERING',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: small ? 10.5 : 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'DEPARTMENT OF BIOMEDICAL ENGINEERING',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF9AA9BC),
            fontSize: small ? 7.2 : 8.5,
            letterSpacing: small ? .65 : 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _nav(
    BuildContext context,
    String text,
    String route,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFD5DFEB),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _menuItem(
                  sheetContext,
                  'Department',
                  Icons.school_outlined,
                  '/',
                ),
                _menuItem(
                  sheetContext,
                  "B'ELITEZ 2K26",
                  Icons.event_outlined,
                  '/events',
                ),
                _menuItem(
                  sheetContext,
                  'Events',
                  Icons.grid_view_rounded,
                  '/events',
                ),
                _menuItem(
                  sheetContext,
                  'Register',
                  Icons.app_registration_rounded,
                  '/register',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.navy),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
