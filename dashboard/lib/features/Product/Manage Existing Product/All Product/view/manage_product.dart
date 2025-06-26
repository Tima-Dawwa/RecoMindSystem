import 'package:dashboard/core/utils/constant.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/manage_product_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ManageProducts extends StatefulWidget {
  const ManageProducts({super.key});

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedProducts = <String>{};
  String _searchQuery = '';
  String? _currentGenderFilter;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: genders.length, vsync: this);
    _currentGenderFilter = genders[0];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllProductCubit>().getAllProducts(page: _currentPage);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onProductTap(String productId) {
    Navigator.pushNamed(context, '/product-details', arguments: productId);
  }

  void _onProductDoubleTap(String productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
      } else {
        _selectedProducts.add(productId);
      }
    });
  }

  void _onDelete() {
    if (_selectedProducts.isEmpty) return;

    final List<String> productIdsToDelete = _selectedProducts.toList();

    context.read<AllProductCubit>().deleteMultipleProducts(
      productIdsToDelete,
      currentPage: _currentPage,
    );

    setState(() {
      _selectedProducts.clear();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1;
    });

    if (value.isEmpty) {
      _applyCurrentFilters();
    } else {
      context.read<AllProductCubit>().searchProducts(value, page: _currentPage);
    }
  }

  void _onSearchClear() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _currentPage = 1;
    });
    _applyCurrentFilters();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedProducts.clear();
      _currentPage = 1;
      _currentGenderFilter = genders[index];
    });
    print('Selected gender: ${genders[index]}');
    _applyCurrentFilters();
  }

  void _applyCurrentFilters() {
    print(
      'Applying filters - Gender: $_currentGenderFilter, Page: $_currentPage, Search: $_searchQuery',
    );

    if (_searchQuery.isNotEmpty) {
      context.read<AllProductCubit>().searchProducts(
        _searchQuery,
        page: _currentPage,
      );
    } else {
      context.read<AllProductCubit>().applyFilters(
        gender: _currentGenderFilter,
        name: null,
        page: _currentPage,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _selectedProducts.clear();
    });
    _applyCurrentFilters();
  }

  void _refreshProducts() {
    setState(() {
      _currentPage = 1;
      _selectedProducts.clear();
    });
    context.read<AllProductCubit>().refreshProducts(page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return ManageProductsContent(
      tabController: _tabController,
      searchController: _searchController,
      selectedProducts: _selectedProducts,
      searchQuery: _searchQuery,
      currentGenderFilter: _currentGenderFilter,
      currentPage: _currentPage,
      onProductTap: _onProductTap,
      onProductDoubleTap: _onProductDoubleTap,
      onDelete: _onDelete,
      onSearchChanged: _onSearchChanged,
      onSearchClear: _onSearchClear,
      onTabChanged: _onTabChanged,
      onPageChanged: _onPageChanged,
      onRefresh: _refreshProducts,
    );
  }
}
