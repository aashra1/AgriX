import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/checkout/domain/entity/checkout_entity.dart';
import 'package:flutter/material.dart';

class PaymentStepWidget extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final Function(PaymentMethod) onMethodSelected;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const PaymentStepWidget({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // We use a Column with MainAxisSize.min to prevent unnecessary expansion
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppStyles.bodyLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildCompactOption(
          method: PaymentMethod.khalti,
          title: 'Khalti Wallet',
          subtitle: 'Instant & Secure',
          icon: Icons.account_balance_wallet_outlined,
          isRecommended: true,
        ),
        const SizedBox(height: 10),
        _buildCompactOption(
          method: PaymentMethod.cod,
          title: 'Cash on Delivery',
          subtitle: 'Pay at your door',
          icon: Icons.payments_outlined,
        ),
        const SizedBox(height: 24),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildCompactOption({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isRecommended = false,
  }) {
    final isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () => onMethodSelected(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryGreen
                    : AppColors.imagePlaceholderGrey.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            // Smaller, cleaner icon box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.primaryGreen
                        : AppColors.inputBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.iconGrey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 6),
                        _buildTinyTag(),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: AppStyles.caption.copyWith(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTinyTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "FAST",
        style: AppStyles.caption.copyWith(
          color: AppColors.primaryGreen,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 50, // Fixed height prevents overflow in small containers
          child: ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Review Order',
              style: AppStyles.buttonText.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: onBack,
          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
          child: Text(
            'Back to shipping',
            style: AppStyles.caption.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
