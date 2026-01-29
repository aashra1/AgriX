import 'dart:io';

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
import 'package:google_fonts/google_fonts.dart';

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

  // Controllers
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

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedImage = File(result.files.first.path!));
    }
  }

  void _nextPage() {
    if (_currentPage == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null || _selectedImage == null) {
        showSnackBar(
          context: context,
          message: 'Please complete all required fields and image',
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
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BusinessHomeScreen()),
          (route) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BusinessHomeScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) => setState(() => _currentPage = page),
          children: [
            _buildFirstPage(w, categoryState.categories),
            _buildSecondPage(w),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage(double w, List<CategoryEntity> categories) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: w * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add your product",
            style: GoogleFonts.crimsonPro(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Please enter all the details",
            style: GoogleFonts.crimsonPro(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            "Add Image:",
            style: GoogleFonts.crimsonPro(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Image that best describes your product",
            style: GoogleFonts.crimsonPro(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  _selectedImage == null
                      ? Icon(Icons.image, size: 50, color: Colors.grey)
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
            ),
          ),
          const SizedBox(height: 20),
          _inputLabel("Product Name"),
          _textField(_nameController, "Product Name"),
          _inputLabel("Category"),
          _dropdownField(categories),
          _inputLabel("Brand / Manufacturer (optional)"),
          _textField(_brandController, "Brand / Manufacturer"),
          _inputLabel("Price"),
          _textField(
            _priceController,
            "Price",
            keyboardType: TextInputType.number,
          ),
          _inputLabel("Discount (optional)"),
          _textField(
            _discountController,
            "Discount",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              backgroundColor: Colors.grey.shade300,
              onPressed: _nextPage,
              child: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSecondPage(double w) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: w * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _inputLabel("Stock"),
          _textField(
            _stockController,
            "Stock",
            keyboardType: TextInputType.number,
          ),
          _inputLabel("Weight/Volume"),
          _textField(
            _weightController,
            "Weight / Volume",
            keyboardType: TextInputType.number,
          ),
          _inputLabel("Unit Type"),
          _textField(_unitTypeController, "Unit Type"),
          _inputLabel("Short Description"),
          _textField(_shortDescriptionController, "Short Description"),
          _inputLabel("Full Description"),
          _textField(
            _fullDescriptionController,
            "Full Description",
            maxLines: 5,
          ),
          const SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: w * 0.6,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B3D0B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isLoading ? null : _submitForm,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Add Product",
                          style: GoogleFonts.crimsonPro(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        text,
        style: GoogleFonts.crimsonPro(
          fontSize: 16,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.crimsonPro(
          color: const Color(0xFF1D264F),
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdownField(List<CategoryEntity> categories) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: _selectedCategoryId,
          hint: Text(
            "Category",
            style: GoogleFonts.crimsonPro(
              color: const Color(0xFF1D264F),
              fontWeight: FontWeight.bold,
            ),
          ),
          items:
              categories
                  .map(
                    (cat) =>
                        DropdownMenuItem(value: cat.id, child: Text(cat.name)),
                  )
                  .toList(),
          onChanged: (val) => setState(() => _selectedCategoryId = val),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
