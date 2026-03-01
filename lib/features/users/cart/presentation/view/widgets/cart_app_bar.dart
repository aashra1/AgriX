import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/home/home_screen.dart';
import 'package:flutter/material.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasItems;
  final VoidCallback onClearCart;
  final VoidCallback? onBack;

  const CartAppBar({
    super.key,
    required this.hasItems,
    required this.onClearCart,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "My Cart",
        style: AppStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            if (onBack != null) {
              onBack!();
              return;
            }
            final bool didPop = await Navigator.of(context).maybePop();

            if (!didPop && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.imagePlaceholderGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textBlack,
              size: 18,
            ),
          ),
        ),
      ),
      actions: [
        if (hasItems)
          IconButton(
            tooltip: 'Clear Cart',
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.logoutRed,
              size: 22,
            ),
            onPressed: onClearCart,
          ),
      ],
    );
  }
}
