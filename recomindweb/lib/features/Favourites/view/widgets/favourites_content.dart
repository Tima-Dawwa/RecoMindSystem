import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Favourites/model/favourites_model.dart';
import 'package:recomindweb/features/Favourites/view/widgets/fav_card.dart';

class FavouritesContent extends StatefulWidget {
  const FavouritesContent({super.key, required this.favouritesItems});
  final List<FavouritesModel> favouritesItems;

  @override
  State<FavouritesContent> createState() => _FavouritesContentState();
}

class _FavouritesContentState extends State<FavouritesContent> {
  @override
  Widget build(BuildContext context) {
    int itemOfFav = widget.favouritesItems.length;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Favourites :',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Themes.primary,
                    ),
                  ),
                  Text(
                    '($itemOfFav Items)',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 20),
            if (widget.favouritesItems.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: Text(
                    "Not Items",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: widget.favouritesItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.favouritesItems[index];
                    return FavCard(
                      name: item.name,
                      imageUrl: "s",
                      price: item.price,
                      department: item.department,
                      isDiscounted: item.isDiscounted,
                      priceDiscounted: item.discountedPrice,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
