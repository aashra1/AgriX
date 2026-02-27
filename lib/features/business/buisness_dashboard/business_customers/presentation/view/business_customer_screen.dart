// lib/features/business/buisness_dashboard/customers/presentation/view/business_customers_screen.dart
import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/business/buisness_dashboard/business_customers/domain/entity/business_customer_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/state/business_order_state.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/viewmodel/business_order_viewmodel.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum CustomerSortBy { name, orders, spent, recent }

enum SortOrder { asc, desc }

enum DateRange { all, week, month, year }

class BusinessCustomersScreen extends ConsumerStatefulWidget {
  const BusinessCustomersScreen({super.key});

  @override
  ConsumerState<BusinessCustomersScreen> createState() =>
      _BusinessCustomersScreenState();
}

class _BusinessCustomersScreenState
    extends ConsumerState<BusinessCustomersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _selectedIndex = 4;
  final TextEditingController _searchController = TextEditingController();

  List<BusinessCustomerEntity> _customers = [];
  List<BusinessCustomerEntity> _filteredCustomers = [];
  bool _isLoading = true;
  String _searchQuery = "";
  CustomerSortBy _sortBy = CustomerSortBy.recent;
  SortOrder _sortOrder = SortOrder.desc;
  DateRange _dateRange = DateRange.all;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterCustomers();
    });
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);

    final token = await ref.read(userSessionServiceProvider).getToken();
    final businessId = ref.read(userSessionServiceProvider).getCurrentauthId();

    if (token == null || businessId == null) {
      _showAuthError();
      return;
    }

    try {
      await ref
          .read(businessOrderViewModelProvider.notifier)
          .getBusinessOrders(
            token: token,
            businessId: businessId,
            page: 1,
            limit: 100,
          );
    } catch (e) {
      setState(() => _isLoading = false);
      showSnackBar(
        context: context,
        message: 'Failed to load customers: $e',
        isSuccess: false,
      );
    }
  }

  void _processOrders(List<BusinessOrderEntity> orders) {
    final Map<String, BusinessCustomerEntity> customerMap = {};

    for (final order in orders) {
      final userId = order.userId;
      final userFullName = order.userFullName ?? 'Unknown Customer';
      final userEmail = order.userEmail ?? '';
      final userPhone = order.userPhone;

      if (!customerMap.containsKey(userId)) {
        customerMap[userId] = BusinessCustomerEntity(
          id: userId,
          fullName: userFullName,
          email: userEmail,
          phone: userPhone,
          totalOrders: 0,
          totalSpent: 0,
          firstOrder: order.createdAt ?? DateTime.now(),
          lastOrder: order.createdAt ?? DateTime.now(),
          addresses: [],
        );
      }

      final customer = customerMap[userId]!;

      final updatedCustomer = BusinessCustomerEntity(
        id: customer.id,
        fullName: customer.fullName,
        email: customer.email,
        phone: customer.phone,
        totalOrders: customer.totalOrders + 1,
        totalSpent: customer.totalSpent + (order.total ?? 0),
        firstOrder:
            customer.firstOrder.isBefore(order.createdAt ?? DateTime.now())
                ? customer.firstOrder
                : (order.createdAt ?? customer.firstOrder),
        lastOrder:
            (order.createdAt ?? customer.lastOrder).isAfter(customer.lastOrder)
                ? (order.createdAt ?? customer.lastOrder)
                : customer.lastOrder,
        addresses: customer.addresses,
      );

      final addressString =
          '${order.shippingAddress.addressLine1}, ${order.shippingAddress.city}';
      if (!(updatedCustomer.addresses?.contains(addressString) ?? false)) {
        final updatedAddresses = [...?updatedCustomer.addresses, addressString];
        customerMap[userId] = updatedCustomer.copyWith(
          addresses: updatedAddresses,
        );
      } else {
        customerMap[userId] = updatedCustomer;
      }
    }

    setState(() {
      _customers = customerMap.values.toList();
      _filterCustomers();
      _isLoading = false;
    });
  }

  void _filterCustomers() {
    var filtered = List<BusinessCustomerEntity>.from(_customers);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered =
          filtered
              .where(
                (customer) =>
                    customer.fullName.toLowerCase().contains(query) ||
                    customer.email.toLowerCase().contains(query) ||
                    (customer.phone?.toLowerCase().contains(query) ?? false),
              )
              .toList();
    }

    if (_dateRange != DateRange.all) {
      final now = DateTime.now();
      final cutoff = DateTime.now();

      switch (_dateRange) {
        case DateRange.week:
          cutoff.subtract(const Duration(days: 7));
          break;
        case DateRange.month:
          cutoff.subtract(const Duration(days: 30));
          break;
        case DateRange.year:
          cutoff.subtract(const Duration(days: 365));
          break;
        default:
          break;
      }

      filtered =
          filtered
              .where((customer) => customer.lastOrder.isAfter(cutoff))
              .toList();
    }

    filtered.sort((a, b) {
      int comparison;

      switch (_sortBy) {
        case CustomerSortBy.name:
          comparison = a.fullName.compareTo(b.fullName);
          break;
        case CustomerSortBy.orders:
          comparison = a.totalOrders.compareTo(b.totalOrders);
          break;
        case CustomerSortBy.spent:
          comparison = a.totalSpent.compareTo(b.totalSpent);
          break;
        case CustomerSortBy.recent:
          comparison = a.lastOrder.compareTo(b.lastOrder);
          break;
      }

      return _sortOrder == SortOrder.asc ? comparison : -comparison;
    });

    setState(() {
      _filteredCustomers = filtered;
    });
  }

  void _handleSort(CustomerSortBy field) {
    setState(() {
      if (_sortBy == field) {
        _sortOrder =
            _sortOrder == SortOrder.asc ? SortOrder.desc : SortOrder.asc;
      } else {
        _sortBy = field;
        _sortOrder = SortOrder.desc;
      }
      _filterCustomers();
    });
  }

  void _showAuthError() {
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/business/login');
    });
  }

  void _handleNavigation(int index) {
    Navigator.pop(context);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/business/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/business/orders');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/business/payments');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/business/profile');
        break;
      case 4:
        break;
      case -1:
        _handleLogout();
        break;
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.logoutRed,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      await ref.read(userSessionServiceProvider).clearSession();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/business/login');
      }
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: 'NPR ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  IconData _getSortIcon(CustomerSortBy field) {
    if (_sortBy != field) return Icons.unfold_more;
    return _sortOrder == SortOrder.asc
        ? Icons.arrow_upward
        : Icons.arrow_downward;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    ref.listen<BusinessOrderState>(businessOrderViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == BusinessOrderStatus.loaded) {
        _processOrders(next.orders);
      } else if (next.status == BusinessOrderStatus.error) {
        setState(() => _isLoading = false);
        showSnackBar(
          context: context,
          message: next.errorMessage ?? 'Failed to load customers',
          isSuccess: false,
        );
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FBF9),
      drawer: BusinessSidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _handleNavigation,
      ),

      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_filteredCustomers.length} ${_filteredCustomers.length == 1 ? 'customer' : 'customers'} found',
                              style: AppStyles.caption.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color:
                                    _showFilters
                                        ? AppColors.primaryGreen
                                        : Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() => _showFilters = !_showFilters);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.download_outlined),
                              onPressed: () {
                                showSnackBar(
                                  context: context,
                                  message: 'Export feature coming soon',
                                  isSuccess: false,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search customers...",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primaryGreen,
                        ),
                        suffixIcon:
                            _searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                                : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_showFilters)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date Range',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterChip('All Time', DateRange.all),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(
                                    'Last 7 Days',
                                    DateRange.week,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(
                                    'Last 30 Days',
                                    DateRange.month,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('Last Year', DateRange.year),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSortChip('Name', CustomerSortBy.name),
                          const SizedBox(width: 8),
                          _buildSortChip('Orders', CustomerSortBy.orders),
                          const SizedBox(width: 8),
                          _buildSortChip('Spent', CustomerSortBy.spent),
                          const SizedBox(width: 8),
                          _buildSortChip('Recent', CustomerSortBy.recent),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        _filteredCustomers.isEmpty
                            ? _buildEmptyState(size)
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredCustomers.length,
                              itemBuilder: (context, index) {
                                return _buildCustomerCard(
                                  _filteredCustomers[index],
                                );
                              },
                            ),
                  ),

                  if (_customers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCard(
                                  icon: Icons.people_outline,
                                  iconColor: Colors.blue,
                                  label: 'Total',
                                  value: '${_customers.length}',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSummaryCard(
                                  icon: Icons.shopping_bag_outlined,
                                  iconColor: Colors.green,
                                  label: 'Avg Orders',
                                  value: (_customers.isEmpty
                                          ? 0
                                          : _customers.fold(
                                                0,
                                                (sum, c) => sum + c.totalOrders,
                                              ) /
                                              _customers.length)
                                      .toStringAsFixed(1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCard(
                                  icon: Icons.attach_money,
                                  iconColor: Colors.purple,
                                  label: 'Avg Spend',
                                  value: _formatCurrency(
                                    _customers.isEmpty
                                        ? 0
                                        : _customers.fold(
                                              0.0,
                                              (sum, c) => sum + c.totalSpent,
                                            ) /
                                            _customers.length,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSummaryCard(
                                  icon: Icons.trending_up,
                                  iconColor: Colors.orange,
                                  label: 'Active',
                                  value:
                                      '${_customers.where((c) => c.lastOrder.isAfter(DateTime.now().subtract(const Duration(days: 30)))).length}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
    );
  }

  Widget _buildFilterChip(String label, DateRange range) {
    final isSelected = _dateRange == range;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _dateRange = selected ? range : DateRange.all;
          _filterCustomers();
        });
      },
      backgroundColor: Colors.grey.shade50,
      selectedColor: AppColors.primaryGreen.withOpacity(0.1),
      checkmarkColor: AppColors.primaryGreen,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryGreen : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryGreen : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, CustomerSortBy field) {
    final isSelected = _sortBy == field;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isSelected) ...[
            const SizedBox(width: 4),
            Icon(_getSortIcon(field), size: 14),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        _handleSort(field);
      },
      backgroundColor: Colors.grey.shade50,
      selectedColor: AppColors.primaryGreen,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      showCheckmark: false,
    );
  }

  Widget _buildCustomerCard(BusinessCustomerEntity customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/business/orders',
            arguments: {'customerId': customer.id},
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        customer.fullName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customer since ${_formatDate(customer.firstOrder)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.shopping_bag_outlined,
                      value: '${customer.totalOrders}',
                      label: 'Orders',
                    ),
                  ),
                  Container(width: 1, height: 30, color: Colors.grey.shade200),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.attach_money,
                      value: _formatCurrency(customer.totalSpent),
                      label: 'Spent',
                    ),
                  ),
                  Container(width: 1, height: 30, color: Colors.grey.shade200),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.access_time,
                      value: _formatDate(customer.lastOrder),
                      label: 'Last',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/business/orders',
                          arguments: {'customerId': customer.id},
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: BorderSide(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View Orders',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (customer.addresses != null &&
                      customer.addresses!.isNotEmpty)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                      tooltip: 'View addresses',
                      itemBuilder: (context) {
                        return customer.addresses!.map((address) {
                          return PopupMenuItem(
                            value: address,
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                address,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryGreen),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: size.width * 0.15,
                color: AppColors.primaryGreen.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No customers found",
              style: AppStyles.headline1.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _searchQuery.isNotEmpty || _dateRange != DateRange.all
                    ? "No customers match your search criteria. Try adjusting your filters."
                    : "You haven't had any customers yet. Orders will appear here once customers start buying.",
                textAlign: TextAlign.center,
                style: AppStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty || _dateRange != DateRange.all)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                      _dateRange = DateRange.all;
                      _filterCustomers();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Clear Filters"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
