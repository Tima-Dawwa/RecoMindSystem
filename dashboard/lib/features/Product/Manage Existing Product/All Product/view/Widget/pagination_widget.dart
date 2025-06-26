import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<int> _getPageNumbers() {
    List<int> pages = [];

    if (totalPages <= 7) {
      // Show all pages if total is 7 or less
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      // Always show first page
      pages.add(1);

      if (currentPage <= 4) {
        // Show pages 1-5 and last page
        for (int i = 2; i <= 5; i++) {
          pages.add(i);
        }
        if (totalPages > 6) {
          pages.add(-1); // Ellipsis
        }
        pages.add(totalPages);
      } else if (currentPage >= totalPages - 3) {
        // Show first page, ellipsis, and last 5 pages
        pages.add(-1); // Ellipsis
        for (int i = totalPages - 4; i <= totalPages; i++) {
          pages.add(i);
        }
      } else {
        // Show first page, ellipsis, current-1, current, current+1, ellipsis, last page
        pages.add(-1); // Ellipsis
        for (int i = currentPage - 1; i <= currentPage + 1; i++) {
          pages.add(i);
        }
        pages.add(-2); // Ellipsis
        pages.add(totalPages);
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final pageNumbers = _getPageNumbers();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First page button
          IconButton(
            onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
            icon: const Icon(Icons.first_page_rounded),
            style: IconButton.styleFrom(
              backgroundColor:
                  currentPage > 1 ? Colors.grey[100] : Colors.grey[50],
              disabledBackgroundColor: Colors.grey[50],
            ),
            tooltip: 'First page',
          ),

          // Previous page button
          IconButton(
            onPressed:
                currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left_rounded),
            style: IconButton.styleFrom(
              backgroundColor:
                  currentPage > 1 ? Colors.grey[100] : Colors.grey[50],
              disabledBackgroundColor: Colors.grey[50],
            ),
            tooltip: 'Previous page',
          ),

          const SizedBox(width: 8),

          // Page numbers
          ...pageNumbers.map((pageNumber) {
            if (pageNumber == -1 || pageNumber == -2) {
              // Ellipsis
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () => onPageChanged(pageNumber),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        currentPage == pageNumber
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          currentPage == pageNumber
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      pageNumber.toString(),
                      style: TextStyle(
                        color:
                            currentPage == pageNumber
                                ? Colors.white
                                : const Color(0xFF4A5568),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(width: 8),

          IconButton(
            onPressed:
                currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
            icon: const Icon(Icons.chevron_right_rounded),
            style: IconButton.styleFrom(
              backgroundColor:
                  currentPage < totalPages ? Colors.grey[100] : Colors.grey[50],
              disabledBackgroundColor: Colors.grey[50],
            ),
            tooltip: 'Next page',
          ),

          IconButton(
            onPressed:
                currentPage < totalPages
                    ? () => onPageChanged(totalPages)
                    : null,
            icon: const Icon(Icons.last_page_rounded),
            style: IconButton.styleFrom(
              backgroundColor:
                  currentPage < totalPages ? Colors.grey[100] : Colors.grey[50],
              disabledBackgroundColor: Colors.grey[50],
            ),
            tooltip: 'Last page',
          ),
        ],
      ),
    );
  }
}
