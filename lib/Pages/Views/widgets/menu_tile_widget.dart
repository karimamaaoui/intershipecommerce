import 'package:flutter/material.dart';
import 'package:internshipapplication/Pages/app_color.dart';

class MenuTileWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final Color iconBackground;
  final Color titleColor;

  MenuTileWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconBackground = AppColor.primarySoft,
    this.titleColor = AppColor.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.primarySoft, width: 1)),
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 46,
              height: 46,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: icon,
            ),
            // Info
            Expanded(
              child: (subtitle == null)
                  ? Text('$title', style: TextStyle(color: titleColor, fontFamily: 'poppins', fontWeight: FontWeight.w500))
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$title', style: TextStyle(color: AppColor.secondary, fontFamily: 'poppins', fontWeight: FontWeight.w500)),
                  SizedBox(height: 2),
                  Text('$subtitle', style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12)),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor.border,
            ),
          ],
        ),
      ),
    );
  }
}