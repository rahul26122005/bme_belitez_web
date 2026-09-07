import 'package:flutter/material.dart';

import '../utils/theme.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;

  const SiteHeader({
    super.key,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.navy,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 76,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 820) {
                return _mobile(context, constraints.maxWidth);
              }
              return _desktop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _mobile(BuildContext context, double width) {
    final tiny = width < 360;
    final logoSize = tiny ? 42.0 : 48.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tiny ? 7 : 10),
      child: Row(
        children: [
          if (showBack) ...[
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 38, height: 42),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 3),
          ],
          Container(
            width: logoSize,
            height: logoSize,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
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
          Expanded(child: _brandText(tiny)),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Menu',
            onPressed: () => _showMenu(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _desktop(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              if (showBack) ...[
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 4),
              ],
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
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
              Expanded(child: _brandText(false)),
              const SizedBox(width: 8),
              _nav(context, 'Department', '/'),
              _nav(context, "B'ELITEZ 2K26", '/register-home'),
              _nav(context, 'Events', '/events'),
              const SizedBox(width: 5),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.teal,
                  foregroundColor: AppTheme.dark,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandText(bool small) {
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
            fontSize: small ? 10.2 : 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'DEPARTMENT OF BIOMEDICAL ENGINEERING',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF9AA9BC),
            fontSize: small ? 7 : 8.5,
            letterSpacing: small ? .55 : 1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _nav(BuildContext context, String text, String route) {
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
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _menuItem(sheetContext, 'Department', Icons.school_outlined, '/'),
              _menuItem(sheetContext, "B'ELITEZ 2K26", Icons.event_outlined, '/register-home'),
              _menuItem(sheetContext, 'Events', Icons.grid_view_rounded, '/events'),
              _menuItem(sheetContext, 'Register', Icons.app_registration_rounded, '/register'),
            ],
          ),
        ),
      ),
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
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
