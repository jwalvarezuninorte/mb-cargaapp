import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    super.key,
    required this.userName,
    required this.imageUrl,
    this.showAddImageAction = false,
  });

  final String userName;
  final bool? showAddImageAction;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);

    return Container(
      width: 160,
      height: 160,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: AppTheme.dark.withOpacity(0.2),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        color: AppTheme.dark.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
      ),
      child: Stack(
        children: [
          imageUrl == null
              ? Center(
                  child: Text(
                    '${userName.split(" ")[0][0]}${userName.split(" ")[1][0]}',
                    style: TextStyle(
                      fontSize: 64,
                      color: AppTheme.dark.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Image.network(
                  imageUrl as String,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
          if (showAddImageAction!)
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.base,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                    side: BorderSide(
                      color: AppTheme.dark.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                ),
                color: AppTheme.dark,
                onPressed: () async {
                  PlatformFile? selectedImage = await loadImageFromGallery();

                  if (selectedImage != null) {
                    await _authService.updateProfilePicture(
                        profilePhoto: selectedImage);
                  }
                },
                icon: Icon(Iconsax.gallery_add),
              ),
            ),
        ],
      ),
    );
  }
}
