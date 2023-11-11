import 'package:cargaapp_mobile/backend/models/user.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    super.key,
    this.showAddImageAction = false,
    required this.userName,
  });

  final String userName;
  final bool? showAddImageAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: AppTheme.dark.withOpacity(0.3),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        color: AppTheme.dark.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '${userName.split(" ")[0][0]}${userName.split(" ")[1][0]}',
              style: TextStyle(
                fontSize: 64,
                color: AppTheme.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (showAddImageAction!)
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.base,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                color: AppTheme.dark,
                onPressed: () async {
                  await loadImageFromGallery();
                },
                icon: Icon(Iconsax.gallery_add),
              ),
            ),
        ],
      ),
    );
  }
}
