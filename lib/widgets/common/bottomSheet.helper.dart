import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/drag_indicator.dart';
import 'package:flutter/material.dart';

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required List<Widget> content,
  CrossAxisAlignment crossAlignment = CrossAxisAlignment.start,
  bool fullHeight = true,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.72),
    isDismissible: false,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: fullHeight ? MediaQuery.of(context).size.height * 0.9 : null,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppTheme.defaultRadius * 2),
              topRight: Radius.circular(AppTheme.defaultRadius * 2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: crossAlignment,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DragIndicator(),
              SizedBox(height: AppTheme.padding),
              ...content
            ],
          ),
        ),
      );
    },
  );
}
