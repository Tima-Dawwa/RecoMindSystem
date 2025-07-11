import 'package:dashboard/core/utils/constant.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product_model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_state.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/bottom_selection.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/product_gridview.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/pagination_widget.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProductsContent extends StatelessWidget {
  final TabController tabController;
  final TextEditingController searchController;
  final Set<String> selectedProducts;
  final String searchQuery;
  final String? currentGenderFilter;
  final int currentPage;
  final Function(String) onProductTap;
  final Function(String) onProductDoubleTap;
  final VoidCallback onDelete;
  final Function(String) onSearchChanged;
  final VoidCallback onSearchClear;
  final Function(int) onTabChanged;
  final Function(int) onPageChanged;
  final VoidCallback onRefresh;

  const ManageProductsContent({
    super.key,
    required this.tabController,
    required this.searchController,
    required this.selectedProducts,
    required this.searchQuery,
    required this.currentGenderFilter,
    required this.currentPage,
    required this.onProductTap,
    required this.onProductDoubleTap,
    required this.onDelete,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onTabChanged,
    required this.onPageChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.bg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBarContainer(context),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar:
          selectedProducts.isNotEmpty
              ? BottomSelectionBar(
                selectedCount: selectedProducts.length,
                onDelete: onDelete,
              )
              : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Text(
            'Manage Products',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          const SizedBox(width: 16),
          SearchBarWidget(
            controller: searchController,
            searchQuery: searchQuery,
            onChanged: onSearchChanged,
            onClear: onSearchClear,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A202C),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: 'Refresh Products',
        ),
      ],
    );
  }

  Widget _buildTabBarContainer(BuildContext context) {
    return Container(
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          onTap: onTabChanged,
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
    );
  }

  Widget _buildBody() {
    return BlocListener<AllProductCubit, AllProductState>(
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
          if (state is LoadingAllProduct || state is SearchingAllProduct) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FailureAllProduct) {
            return _buildErrorState(state);
          }

          return _buildSuccessState(state);
        },
      ),
    );
  }

  Widget _buildErrorState(FailureAllProduct state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
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
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRefresh, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildSuccessState(AllProductState state) {
    List<AllProductModel> products = [];
    int totalCount = 0;
    int displayCurrentPage = 1;
    int totalPages = 1;

    if (state is SuccessAllProduct) {
      products = state.products;
      totalCount = state.totalCount;
      displayCurrentPage = state.currentPage;
      totalPages = state.totalPages;
    } else if (state is SearchSuccessAllProduct) {
      products = state.searchResults;
      totalCount = state.totalCount;
      displayCurrentPage = state.currentPage;
      totalPages = state.totalPages;
    }

    if (state is SuccessAllProduct || state is SearchSuccessAllProduct) {
      if (currentPage == 1 && displayCurrentPage == 1) {
      } else {
        displayCurrentPage = currentPage;
      }
    }

    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return _buildProductsList(
      products,
      totalCount,
      displayCurrentPage,
      totalPages,
    );
  }

  Widget _buildEmptyState() {
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? 'No products match your search "$searchQuery"'
                : 'Try adjusting your filters or refresh the page.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRefresh, child: const Text('Refresh')),
        ],
      ),
    );
  }

  Widget _buildProductsList(
    List<AllProductModel> products,
    int totalCount,
    int displayCurrentPage,
    int totalPages,
  ) {
    return Column(
      children: [
        _buildProductsHeader(
          products,
          totalCount,
          displayCurrentPage,
          totalPages,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              onRefresh();
            },
            child: ProductsGridView(
              products: products,
              selectedProducts: selectedProducts,
              onProductTap: onProductTap,
              onProductDoubleTap: onProductDoubleTap,
              onLoadMore: null,
            ),
          ),
        ),
        if (totalPages > 1) _buildPaginationWidget(totalPages),
      ],
    );
  }

  Widget _buildProductsHeader(
    List<AllProductModel> products,
    int totalCount,
    int displayCurrentPage,
    int totalPages,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              'Page $currentPage of $totalPages',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaginationWidget(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: PaginationWidget(
        currentPage: currentPage,
        totalPages: totalPages,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
