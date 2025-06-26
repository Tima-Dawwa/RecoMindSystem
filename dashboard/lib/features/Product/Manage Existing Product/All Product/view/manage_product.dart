import 'package:dashboard/core/utils/constant.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product_model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_state.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/product_gridview.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Widget/search_bar.dart';
import 'Widget/bottom_selection.dart';

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
      _currentPage = 1; // Reset to first page when searching
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
      _currentPage = 1; // Reset to first page when changing tabs
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
    print('Page changed to: $page');
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Manage Products',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const SizedBox(width: 16),
            SearchBarWidget(
              controller: _searchController,
              searchQuery: _searchQuery,
              onChanged: _onSearchChanged,
              onClear: _onSearchClear,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A202C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
            tooltip: 'Refresh Products',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                    ),
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 0,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.1,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 0.1,
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: _onTabChanged,
                    tabs:
                        genders.map((category) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Text(category),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocListener<AllProductCubit, AllProductState>(
              listener: (context, state) {
                if (state is DeleteSuccessAllProduct) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Products deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                if (state is FailureAllProduct) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.failure.errMessage}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: BlocBuilder<AllProductCubit, AllProductState>(
                builder: (context, state) {
                  if (state is LoadingAllProduct ||
                      state is SearchingAllProduct) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FailureAllProduct) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading products',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.failure.errMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshProducts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  List<AllProductModel> products = [];
                  int totalCount = 0;
                  int currentPage = 1;
                  int totalPages = 1;

                  if (state is SuccessAllProduct) {
                    products = state.products;
                    totalCount = state.totalCount;
                    currentPage = state.currentPage;
                    totalPages = state.totalPages;
                  } else if (state is SearchSuccessAllProduct) {
                    products = state.searchResults;
                    totalCount = state.totalCount;
                    currentPage = state.currentPage;
                    totalPages = state.totalPages;
                  }

                  // Don't update _currentPage from state if we're navigating
                  // Only sync it during initial load or refresh
                  if (state is SuccessAllProduct ||
                      state is SearchSuccessAllProduct) {
                    // Only update local page state if it's the initial load
                    if (_currentPage == 1 && currentPage == 1) {
                      // This is likely an initial load, safe to sync
                    } else {
                      // Use our local page state for display
                      currentPage = _currentPage;
                    }
                  }

                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.sentiment_dissatisfied,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No products match your search "${_searchQuery}"'
                                : 'Try adjusting your filters or refresh the page.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshProducts,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing ${products.length} of $totalCount products',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (totalPages > 1)
                              Text(
                                'Page ${_currentPage} of $totalPages',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _refreshProducts();
                          },
                          child: ProductsGridView(
                            products: products,
                            selectedProducts: _selectedProducts,
                            onProductTap: _onProductTap,
                            onProductDoubleTap: _onProductDoubleTap,
                            onLoadMore: null,
                          ),
                        ),
                      ),

                      // Pagination widget
                      if (totalPages > 1)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                          ),
                          child: PaginationWidget(
                            currentPage: _currentPage,
                            totalPages: totalPages,
                            onPageChanged: _onPageChanged,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          _selectedProducts.isNotEmpty
              ? BottomSelectionBar(
                selectedCount: _selectedProducts.length,
                onDelete: _onDelete,
              )
              : null,
    );
  }
}
