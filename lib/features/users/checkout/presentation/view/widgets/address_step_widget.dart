import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/checkout/domain/entity/checkout_entity.dart';
import 'package:flutter/material.dart';

class AddressStepWidget extends StatefulWidget {
  final List<AddressEntity> addresses;
  final int selectedAddressIndex;
  final Function(int) onAddressSelected;
  final VoidCallback onContinue;
  final bool showNewAddressForm;
  final VoidCallback onAddNewAddress;
  final VoidCallback onCancelNewAddress;
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final VoidCallback onSaveAddress;
  final VoidCallback? onUseCurrentLocation;
  final bool isFetchingLocation;
  final String? locationInfoText;

  const AddressStepWidget({
    super.key,
    required this.addresses,
    required this.selectedAddressIndex,
    required this.onAddressSelected,
    required this.onContinue,
    required this.showNewAddressForm,
    required this.onAddNewAddress,
    required this.onCancelNewAddress,
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.onSaveAddress,
    this.onUseCurrentLocation,
    this.isFetchingLocation = false,
    this.locationInfoText,
  });

  @override
  State<AddressStepWidget> createState() => _AddressStepWidgetState();
}

class _AddressStepWidgetState extends State<AddressStepWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Select Delivery Address'),
        const SizedBox(height: 10),
        _buildLocationAction(),
        const SizedBox(height: 16),
        _buildAddressList(),
        const SizedBox(height: 12),
        _buildAddNewAddressAction(),
        if (widget.showNewAddressForm) _buildNewAddressForm(),
        const SizedBox(height: 32),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildLocationAction() {
    if (widget.onUseCurrentLocation == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed:
                widget.isFetchingLocation ? null : widget.onUseCurrentLocation,
            icon:
                widget.isFetchingLocation
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.my_location, size: 18),
            label: Text(
              widget.isFetchingLocation
                  ? 'Detecting location...'
                  : 'Use Current Location',
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryGreen),
              foregroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (widget.locationInfoText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.locationInfoText!,
            style: AppStyles.caption.copyWith(color: AppColors.textGrey),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppStyles.bodyLarge.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAddressList() {
    return Column(
      children:
          widget.addresses.asMap().entries.map((entry) {
            final index = entry.key;
            final addr = entry.value;
            final isSelected = widget.selectedAddressIndex == index;

            return GestureDetector(
              onTap: () => widget.onAddressSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.primaryGreen
                            : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isSelected
                              ? AppColors.primaryGreen.withOpacity(0.1)
                              : Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color:
                          isSelected
                              ? AppColors.primaryGreen
                              : AppColors.iconGrey,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(addr.fullName, style: AppStyles.bodyLarge),
                              if (addr.isDefault) ...[
                                const SizedBox(width: 10),
                                _buildTag("DEFAULT"),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${addr.addressLine1}${addr.addressLine2 != null ? ', ${addr.addressLine2}' : ''}",
                            style: AppStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          Text(
                            "${addr.city}, ${addr.state} - ${addr.postalCode}",
                            style: AppStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_android,
                                size: 14,
                                color: AppColors.textLightGrey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                addr.phone,
                                style: AppStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppStyles.caption.copyWith(
          color: AppColors.primaryGreen,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddNewAddressAction() {
    if (widget.showNewAddressForm) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onAddNewAddress,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.imagePlaceholderGrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.add_location_alt_outlined,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 8),
            Text(
              "Add New Shipping Address",
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewAddressForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            _buildField(
              widget.fullNameController,
              'Full Name',
              Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildField(
              widget.phoneController,
              'Phone Number',
              Icons.phone_iphone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildField(
              widget.addressLine1Controller,
              'Address Line 1',
              Icons.map_outlined,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildField(widget.cityController, 'City', null),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildField(widget.stateController, 'State', null),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildField(
              widget.postalCodeController,
              'Postal Code',
              Icons.pin_drop_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancelNewAddress,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.logoutRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppStyles.buttonText.copyWith(
                        color: AppColors.logoutRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onSaveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Save Address",
                      style: AppStyles.buttonText.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData? icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.caption.copyWith(fontSize: 14),
        prefixIcon:
            icon != null
                ? Icon(icon, color: AppColors.primaryGreen, size: 20)
                : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
      validator:
          (val) => val?.isEmpty ?? true ? 'This field is required' : null,
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          shadowColor: AppColors.primaryGreen.withOpacity(0.4),
        ),
        child: Text(
          "Continue to Payment",
          style: AppStyles.buttonText.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
