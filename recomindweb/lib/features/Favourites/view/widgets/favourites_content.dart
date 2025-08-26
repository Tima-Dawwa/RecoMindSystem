import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Favourites/model/favourites_model.dart';
import 'package:recomindweb/features/Favourites/view%20model/cubit/favourites_cubit.dart';
import 'package:recomindweb/features/Favourites/view%20model/cubit/favourites_state.dart';
import 'package:recomindweb/features/Favourites/view/widgets/fav_card.dart';
import 'package:recomindweb/features/Favourites/view/widgets/fav_card_mobile.dart';

class FavouritesContent extends StatefulWidget {
  const FavouritesContent({
    super.key,
    required this.favouritesItems,
    required this.desktop,
  });
  final List<FavouritesModel> favouritesItems;
  final bool desktop;

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
              BlocBuilder<FavouritesCubit, FavouritesState>(
                builder: (context, state) {
                  if (state is RemoveFavouritesLoadingState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 250),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: widget.favouritesItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.favouritesItems[index];
                          if (widget.desktop) {
                            return FavCard(
                              name: item.name,
                              imageUrl:item.image,
                              price: item.price,
                              department: item.department,
                              isDiscounted: item.isDiscounted,
                              priceDiscounted: item.discountedPrice,
                              removeFav: () => _removeFav(item.id),
                            );
                          }
                          return FavCardMobile(
                            name: item.name,
                            imageUrl: item.image,
                            price: item.price,
                            department: item.department,
                            isDiscounted: item.isDiscounted,
                            priceDiscounted: item.discountedPrice,
                            removeFav: () => _removeFav(item.id),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _removeFav(String id) {
    BlocProvider.of<FavouritesCubit>(context).removeFromFavourites(id: id);
  }
}
