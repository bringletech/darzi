import 'package:darzi/Reusable/text_reusable_pop.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard_new.dart';
import 'package:flutter/material.dart';

class CustomAppBars extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final IconData icon;
  final bool enableBack;
  final Widget? child;
  final Locale? locale;

  const CustomAppBars({
    super.key,
    this.title,
    this.icon = Icons.arrow_back_ios,
    this.enableBack = true,
    this.child,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(icon, color: AppColors.blackTextColor),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerDashboardNew(
                locale: locale ?? const Locale('en'),
              ),
            ),
          );
        },
      ),
      title: child ??
          (title != null && title!.isNotEmpty
              ? TextResPopp(
                  FontWeight.w600,
                  title!,
                  24,
                )
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
