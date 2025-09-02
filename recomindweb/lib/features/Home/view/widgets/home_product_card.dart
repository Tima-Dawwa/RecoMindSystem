import 'package:flutter/material.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Home/model/collab_product_model.dart';

class HomeProductCard extends StatefulWidget {
  const HomeProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.width,
  });
  final CollabProductModel product;
  final VoidCallback onTap;
  final double width;

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard> {
  bool isFavorite = false;
  int totalStars = 5;
  int fullStars = 0;
  bool halfStar = false;
  Api? api;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fullStars = widget.product.rating.floor();
    halfStar = (widget.product.rating - widget.product.rating.floor()) >= 0.5;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: Themes.bg,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Themes.text.withAlpha(30),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Stack(
                  children: [
                    Image.network(
                      '${getIt.get<Api>().baseUrl}${widget.product.image}',
                      headers: {"ngrok-skip-browser-warning": "true"},
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder:
                          (_, __, ___) => Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: Icon(Icons.image, size: 40),
                            ),
                          ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Themes.bg,
                            shape: BoxShape.circle,
                          ),
                          child: 
                          Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite
                                    ? Themes.secondary
                                    : Themes.text.withAlpha(100),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.015,
                      color: Themes.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.013,
                          color: Themes.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${(widget.product.price * 1.2).toStringAsFixed(2)}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: MediaQuery.of(context).size.width * 0.012,
                          color: Themes.text.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(totalStars, (index) {
                      if (index < fullStars) {
                        return Icon(Icons.star, size: MediaQuery.of(context).size.width * 0.015, color: Themes.third);
                      } else if (index == fullStars && halfStar) {
                        return Icon(
                          Icons.star_half,
                          size: MediaQuery.of(context).size.width * 0.015,
                          color: Themes.third,
                        );
                      } else {
                        return  Icon(
                          Icons.star_border,
                          size: MediaQuery.of(context).size.width * 0.015,
                          color: Colors.grey,
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
