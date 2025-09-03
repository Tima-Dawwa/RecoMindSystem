import 'package:flutter/material.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';

class FavCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String department;
  final bool isDiscounted;
  final double priceDiscounted;
  final VoidCallback removeFav;

  const FavCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.department,
    required this.isDiscounted,
    required this.priceDiscounted,
    required this.removeFav,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            // Container(width: 100, height: 100, color: Colors.amber),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${getIt.get<Api>().baseUrl}$imageUrl",
                headers: {
                  "ngrok-skip-browser-warning": "true",
                }, //     width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(child: Icon(Icons.image, size: 50)),
                    ),
              ),
            ),
            const SizedBox(width: 20),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    department,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            //Price
            Expanded(
              child:
                  isDiscounted
                      ? Column(
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          Text("Price"),
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child:
                  isDiscounted
                      ? Column(
                        children: [
                          Text(
                            "price discounted",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${priceDiscounted.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                      : Column(children: [Text("Discount coming soon")]),
            ),
            SizedBox(width: 50),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red, size: 32),
              onPressed: removeFav,
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
