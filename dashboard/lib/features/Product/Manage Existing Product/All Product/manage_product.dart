import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Widget/data_sample.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/product_details.dart';
import 'package:flutter/material.dart';
import 'Widget/search_bar.dart';
import 'Widget/product_gridview.dart';
import 'Widget/pagination_widget.dart';
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
  int _currentPage = 1;
  final int _itemsPerPage = 8;
  String _searchQuery = '';

  List<Product> _allProducts = List.from(SampleProducts.products);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: SampleProducts.categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    List<Product> products = _allProducts;

    if (_tabController.index > 0) {
      String selectedCategory = SampleProducts.categories[_tabController.index];
      products =
          products
              .where((product) => product.category == selectedCategory)
              .toList();
    }

    if (_searchQuery.isNotEmpty) {
      products =
          products
              .where(
                (product) => product.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    return products;
  }

  List<Product> get _paginatedProducts {
    final filtered = _filteredProducts;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= filtered.length) return [];

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  int get _totalPages {
    return (_filteredProducts.length / _itemsPerPage).ceil();
  }

  void _onProductTap(String productId) {
    final product = _allProducts.firstWhere((p) => p.id == productId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(product: product),
      ),
    );
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
    setState(() {
      _allProducts.removeWhere(
        (product) => _selectedProducts.contains(product.id),
      );
      _selectedProducts.clear();

      if (_currentPage > _totalPages && _totalPages > 0) {
        _currentPage = _totalPages;
      } else if (_totalPages == 0) {
        _currentPage = 1;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1;
    });
  }

  void _onSearchClear() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _currentPage = 1;
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentPage = 1;
      _selectedProducts.clear();
    });
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

                    // Smooth transitions
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),

                    onTap: _onTabChanged,
                    tabs:
                        SampleProducts.categories.map((category) {
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
            child: TabBarView(
              controller: _tabController,
              children:
                  SampleProducts.categories.map((category) {
                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ProductsGridView(
                              products: _paginatedProducts,
                              selectedProducts: _selectedProducts,
                              onProductTap: _onProductTap,
                              onProductDoubleTap: _onProductDoubleTap,
                            ),
                          ),
                        ),
                        if (_totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: PaginationWidget(
                              currentPage: _currentPage,
                              totalPages: _totalPages,
                              onPageChanged: _onPageChanged,
                            ),
                          ),
                      ],
                    );
                  }).toList(),
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
