import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/features/category/domain/entity/category_entity.dart';
import 'package:agrix/features/category/presentation/state/category_state.dart';
import 'package:agrix/features/category/presentation/view/category_detail_page.dart';
import 'package:agrix/features/category/presentation/viewmodel/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesGrid extends ConsumerStatefulWidget {
  const CategoriesGrid({super.key});

  @override
  ConsumerState<CategoriesGrid> createState() => _CategoriesGridState();
}

class _CategoriesGridState extends ConsumerState<CategoriesGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    await ref.read(categoryViewModelProvider.notifier).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double gridPadding = screenWidth * 0.05;
    final double iconSize = screenWidth * 0.08;
    final double spacing = screenWidth * 0.03;
    final double fontSize = screenWidth * 0.035;

    if (categoryState.status == CategoryStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      );
    }

    if (categoryState.status == CategoryStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Failed to load categories',
              style: GoogleFonts.crimsonPro(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadCategories,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final categories = categoryState.categories;

    if (categories.isEmpty) {
      return Center(
        child: Text(
          'No categories available',
          style: GoogleFonts.crimsonPro(fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gridPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth < 600 ? 2 : 3,
          childAspectRatio: screenWidth / screenHeight * 2.2,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CategoryDetailScreen(category: category),
                ),
              );
            },
            child: _buildCategoryItem(category, iconSize, spacing, fontSize),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(
    CategoryEntity category,
    double iconSize,
    double spacing,
    double fontSize,
  ) {
    String iconPath = _getCategoryIcon(category.name);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(spacing),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
            color: const Color(0xFFEBB61B),
            errorBuilder:
                (context, error, stackTrace) => Icon(
                  Icons.category,
                  size: iconSize,
                  color: const Color(0xFFEBB61B),
                ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Text(
              category.name,
              style: GoogleFonts.crimsonPro(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: iconSize * 0.5,
            height: iconSize * 0.5,
            child: Image.asset(
              'assets/icons/to-right.png',
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.arrow_forward_ios,
                    size: iconSize * 0.3,
                    color: Colors.grey,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('seed') || name.contains('plant')) {
      return 'assets/icons/seeds.png';
    } else if (name.contains('fertilizer') || name.contains('soil')) {
      return 'assets/icons/fertilizer.png';
    } else if (name.contains('irrigation') || name.contains('water')) {
      return 'assets/icons/water-system.png';
    } else if (name.contains('pesticide')) {
      return 'assets/icons/pesticide.png';
    } else if (name.contains('animal') || name.contains('livestock')) {
      return 'assets/icons/sheep.png';
    } else if (name.contains('machinery') || name.contains('equipment')) {
      return 'assets/icons/tractor.png';
    }

    return 'assets/icons/seeds.png';
  }
}
