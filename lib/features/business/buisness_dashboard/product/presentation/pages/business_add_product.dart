import 'dart:io';

import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/business/buisness_dashboard/business_homepage.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/state/business_product_state.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/viewmodel/business_product_viewmodel.dart';
import 'package:agrix/features/category/domain/entity/category_entity.dart';
import 'package:agrix/features/category/presentation/viewmodel/category_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessAddProductScreen extends ConsumerStatefulWidget {
  const BusinessAddProductScreen({super.key});

  @override
  ConsumerState<BusinessAddProductScreen> createState() =>
      _BusinessAddProductScreenState();
}

class _BusinessAddProductScreenState
    extends ConsumerState<BusinessAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _stockController = TextEditingController();
  final _weightController = TextEditingController();
  final _unitTypeController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _fullDescriptionController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryViewModelProvider.notifier).getCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _weightController.dispose();
    _unitTypeController.dispose();
    _shortDescriptionController.dispose();
    _fullDescriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedImage = File(result.files.first.path!));
    }
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        showSnackBar(
          context: context,
          message: 'Please add a product image',
          isSuccess: false,
        );
        return;
      }
      if (_selectedCategoryId == null) {
        showSnackBar(
          context: context,
          message: 'Please select a category',
          isSuccess: false,
        );
        return;
      }

      setState(() => _isLoading = true);
      final token = await ref.read(userSessionServiceProvider).getToken();

      if (token == null) {
        showSnackBar(
          context: context,
          message: 'Authentication required.',
          isSuccess: false,
        );
        setState(() => _isLoading = false);
        return;
      }

      await ref
          .read(productViewModelProvider.notifier)
          .addProduct(
            name: _nameController.text.trim(),
            categoryId: _selectedCategoryId!,
            price: double.parse(_priceController.text.trim()),
            stock: int.parse(_stockController.text.trim()),
            brand: _brandController.text.trim(),
            discount: double.tryParse(_discountController.text.trim()),
            weight: double.tryParse(_weightController.text.trim()),
            unitType: _unitTypeController.text.trim(),
            shortDescription: _shortDescriptionController.text.trim(),
            fullDescription: _fullDescriptionController.text.trim(),
            imagePath: _selectedImage!.path,
            token: token,
          );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final categoryState = ref.watch(categoryViewModelProvider);

    ref.listen<ProductState>(productViewModelProvider, (previous, next) {
      if (next.status == ProductStatus.added) {
        showSnackBar(
          context: context,
          message: 'Product added successfully!',
          isSuccess: true,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BusinessHomeScreen()),
          (route) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textBlack,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Add New Product',
          style: AppStyles.bodyLarge.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildStepper(w),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged:
                    (int page) => setState(() => _currentPage = page),
                children: [
                  _buildFirstPage(w, categoryState.categories),
                  _buildSecondPage(w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Row(
        children: [
          _stepperCircle(isActive: true, label: "1"),
          Expanded(
            child: Divider(
              color:
                  _currentPage == 1
                      ? AppColors.primaryGreen
                      : AppColors.backgroundGrey,
              thickness: 2,
            ),
          ),
          _stepperCircle(isActive: _currentPage == 1, label: "2"),
        ],
      ),
    );
  }

  Widget _stepperCircle({required bool isActive, required String label}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryGreen : AppColors.backgroundGrey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFirstPage(double w, List<CategoryEntity> categories) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Product Overview",
            style: AppStyles.headline1.copyWith(fontSize: 22),
          ),
          Text(
            "Start by adding an image and basic info",
            style: AppStyles.bodyMedium.copyWith(color: AppColors.textGrey),
          ),
          const SizedBox(height: 25),
          _sectionHeader("Product Visual"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.backgroundGrey),
              ),
              child:
                  _selectedImage == null
                      ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                            color: AppColors.iconGrey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Tap to upload",
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ],
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
            ),
          ),
          const SizedBox(height: 25),
          _sectionHeader("Identification"),
          _inputLabel("Product Name"),
          _textField(_nameController, "e.g. Fresh Tomatoes", isRequired: true),
          _inputLabel("Category"),
          _dropdownField(categories),
          _inputLabel("Brand (Optional)"),
          _textField(_brandController, "e.g. Local Farms"),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputLabel("Price (NPR)"),
                    _textField(
                      _priceController,
                      "0.00",
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputLabel("Discount (%)"),
                    _textField(
                      _discountController,
                      "0",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSecondPage(double w) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _sectionHeader("Inventory Details"),
          _inputLabel("Initial Stock"),
          _textField(
            _stockController,
            "Amount available",
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputLabel("Weight/Vol"),
                    _textField(
                      _weightController,
                      "e.g. 1.5",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputLabel("Unit Type"),
                    _textField(_unitTypeController, "e.g. kg, ltr"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _sectionHeader("Description"),
          _inputLabel("Short Tagline"),
          _textField(_shortDescriptionController, "Brief catchy summary..."),
          _inputLabel("Full Details"),
          _textField(
            _fullDescriptionController,
            "Detailed product info...",
            maxLines: 5,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousPage,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.backgroundGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Back", style: AppStyles.bodyMedium),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            "Add Product",
                            style: AppStyles.buttonText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: AppStyles.bodyLarge.copyWith(
        color: AppColors.primaryGreen,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: Text(
        text,
        style: AppStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.inputField.copyWith(
          color: AppColors.textGrey.withOpacity(0.5),
        ),
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          (val) =>
              isRequired && (val == null || val.isEmpty) ? "Required" : null,
    );
  }

  Widget _dropdownField(List<CategoryEntity> categories) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: _selectedCategoryId,
          items:
              categories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name, style: AppStyles.bodyMedium),
                    ),
                  )
                  .toList(),
          onChanged: (val) => setState(() => _selectedCategoryId = val),
          decoration: const InputDecoration(border: InputBorder.none),
          validator: (val) => val == null ? "Select Category" : null,
        ),
      ),
    );
  }
}
