import 'package:flutter/material.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';

class SingleComment extends StatelessWidget {
  const SingleComment({
    required this.comment,
    required this.date,
    required this.imageUrl,
    required this.name,
    super.key,
  });

  final String comment;
  final String date;
  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.padding / 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius / 2),
        border: Border.all(color: AppTheme.primary, width: 0.2),
        color: Colors.grey[50],
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                ],
              ),
              Spacer(),
              Text(date),
            ],
          ),
          Divider(),
          Text(comment, textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
