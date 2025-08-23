import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recomindweb/features/Favourites/model/favourites_model.dart';
import 'package:recomindweb/features/Favourites/view/widgets/favourites_content.dart';

class FavouritesPageBody extends StatefulWidget {
  const FavouritesPageBody({
    super.key,
    required this.favouritesItems,
    required this.desktop,
  });
  final List<FavouritesModel> favouritesItems;
  final bool desktop;

  @override
  State<FavouritesPageBody> createState() => _FavouritesPageBodyState();
}

class _FavouritesPageBodyState extends State<FavouritesPageBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.desktop) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FavouritesContent(favouritesItems: widget.favouritesItems),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            FavouritesContent(favouritesItems: widget.favouritesItems),
          ],
        ),
      );
    }
  }
}
