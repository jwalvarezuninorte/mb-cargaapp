import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/app_theme.dart';

class GoBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GoBackAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 120,
      backgroundColor: Colors.transparent,
      leading: TextButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        label: Text('Atrás', style: TextStyle(color: AppTheme.dark)),
        icon: const Icon(
          FontAwesomeIcons.chevronLeft,
          color: AppTheme.dark,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
